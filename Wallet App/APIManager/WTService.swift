//
//  WTService.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 25.11.2023.
//

import Foundation

final class WTService {
    /// Shared singleton instance
    static let shared = WTService()

    /// Privatized constructor
    private init() {}

    /// Error types
    enum WTServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    private func request(from wtRequest: WTRequest, body: Data?,
                         accessToken: String? = nil, refreshToken: String? = nil) -> URLRequest? {

        guard let url = wtRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = wtRequest.httpMethod

        if let body = body {
            request.httpBody = body
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        if let refreshToken = refreshToken {
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }


    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func executeRequest<T: Codable>(
        _ request: WTRequest,
        body: Data? = nil,
        accessToken: String? = LocalState.accessToken,
        refreshToken: String? = nil,
        expected responseType: T.Type,
        completion: @escaping (Result<T, Error>, Int?) -> Void
    ) {
        guard let urlRequest = self.request(from: request, body: body, 
                                            accessToken: accessToken, refreshToken: refreshToken) else {
            completion(.failure(WTServiceError.failedToCreateRequest), nil)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            let statusCode = response.statusCode

            guard let data = data, error == nil else{
                completion(.failure(error ?? WTServiceError.failedToGetData), nil)
                return
            }

            // Decode response
            do {
                SwiftyBeaverConfig.shared.logDebug(
                    "Decoding response...\nSource - ***** \(String(describing: urlRequest.url!)) *****"
                )
                SwiftyBeaverConfig.shared.logInfo(String(data: data, encoding: .utf8) ?? "unable to read")
                let result = try JSONDecoder().decode(responseType.self, from: data)
                completion(.success(result), statusCode)
            }
            catch {
                SwiftyBeaverConfig.shared.logError("Failed to decode response")
                SwiftyBeaverConfig.shared.logInfo(
                    "Describtion - \(String(describing: error))\nStatus code - \(statusCode)"
                )
                completion(.failure(error), statusCode)
            }
        }
        task.resume()
    }

    public func requestBody(body: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            return jsonData
        } catch {
            print("failed")
            return nil
        }
    }

    public func refreshSession(completion: @escaping (Bool) -> Void) {
        let sessionId = LocalState.sessionId
        let refreshToken = LocalState.refreshToken
        
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: ["sid": sessionId])
        } catch {
            print("failed to create refresh body")
        }

        let request = WTRequest(
            endpoint: .auth,
            httpMethod: .post,
            pathComponents: ["refresh"]
        )

        self.executeRequest(request, body: jsonData, refreshToken: refreshToken,
                            expected: WTRefreshResponse.self) { result, statusCode in
            switch result {
            case .success(let refreshData):
                LocalState.refreshData = refreshData
                completion(true)
            case .failure(let failure):
                SwiftyBeaverConfig.shared.logError("Auth refresh error")
                SwiftyBeaverConfig.shared.logInfo(String(describing: failure))
                completion(false)
            }
        }
    }
}

//
//  LocalState.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 26.11.2023.
//

import Foundation

public class LocalState {

    private enum Keys: String {
        case hasLoggedIn
        case logiInData
        case refreshData
    }

    public static var userName: String? {
        return loginData?.data.user.name
    }

    public static var balance: Int = 0

    public static var sessionId: String = {
        guard let refreshData = refreshData else {
            return loginData?.data.sid ?? "sid is missed"
        }
        return refreshData.data.sid
    }()

    public static var accessToken: String = {
        guard let refreshData = refreshData else {
            return loginData?.data.accessToken ?? "accessToken is missed"
        }
        return refreshData.data.accessToken
    }()

    public static var refreshToken: String = {
        guard let refreshData = refreshData else {
            return loginData?.data.refreshToken ?? "refreshToken is missed"
        }
        return refreshData.data.refreshToken
    }()

    public static var hasLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasLoggedIn.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasLoggedIn.rawValue)
        }
    }

    static var loginData: WTLoginResponse? {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.logiInData.rawValue),
               let decodedModel = try? JSONDecoder().decode(WTLoginResponse.self, from: data) {
                return decodedModel
            }
            return nil
        }
        set(newValue) {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(encodedData, forKey: Keys.logiInData.rawValue)
            }
            guard let accessToken = newValue?.data.accessToken,
                  let refreshToken = newValue?.data.refreshToken,
                  let sessionId = newValue?.data.sid else {
                return
            }
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.sessionId = sessionId
        }
    }

    static var refreshData: WTRefreshResponse? {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.refreshData.rawValue),
               let decodedModel = try? JSONDecoder().decode(WTRefreshResponse.self, from: data) {
                return decodedModel
            }
            return nil
        }
        set(newValue) {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(encodedData, forKey: Keys.refreshData.rawValue)
            }
            guard let accessToken = newValue?.data.accessToken,
                  let refreshToken = newValue?.data.refreshToken,
                  let sessionId = newValue?.data.sid else {
                return
            }
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.sessionId = sessionId
        }
    }
}

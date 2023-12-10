//
//  SwiftyBeaverConfig.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 10.12.2023.
//

import Foundation
import SwiftyBeaver

class SwiftyBeaverConfig {
    static let shared = SwiftyBeaverConfig()

    private let log = SwiftyBeaver.self

    private init() {
        configureLogging()
    }

    private func configureLogging() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }

    func logDebug(_ message: String) {
        log.debug("\(message.uppercased())")
    }

    func logInfo(_ message: String) {
        log.info("\n***\n***\n \(message)\n***\n***")
    }

    func logError(_ message: String) {
        log.error("\n====\n \(message.uppercased())\n====\n")
    }
}

//
//  LogWriter.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation
import os.log

public final class LogWriter {

    public struct Levels: OptionSet {
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public let rawValue: Int
        public static let error = Self(rawValue: 1 << 0)
        public static let warning = Self(rawValue: 1 << 1)
        public static let notice = Self(rawValue: 1 << 2)
        public static let info = Self(rawValue: 1 << 3)
        public static let debug: Self = [.error, .warning, .notice]
        public static let none: Self = []
        public static let all: Self = [.debug, .info]

        var symbol: String {
            switch true {
            case contains(.error): "🔴"
            case contains(.warning): "🟠"
            case contains(.notice): "🟣"
            case contains(.info): "🔵"
            default: ""
            }
        }
    }

    private let loggingSystem: LoggingSystemType
    private let prefixWord: String
    private let attributes: LoggerAttributes
    private var beginTimeStamp = Date()
    private let levelSettings: Levels

    public init(_ prefix: LogPrefixType = .init(value: "##"),
                attributes: LoggerAttributes = .default,
                level: Levels = .all,
                loggingSystem: LoggingSystemType = ConsoleLogger())
    {
        levelSettings = level
        prefixWord = prefix.value
        self.attributes = attributes
        self.loggingSystem = loggingSystem
    }

    public func log(
        _ input: Any?,
        _ type: LoggerStatus = .none,
        _ level: Levels,
        forcedAttributes: LoggerAttributes? = nil,
        funcname: String = #function,
        filename: String = #file,
        line: Int = #line
    ) {
        guard levelSettings.contains(level) else {
            return
        }
        var file: String? {
            filename.components(separatedBy: "/").last?.components(separatedBy: ".").first
        }

        var prefix = [String]()
        if attributes.contains(.prefix) {
            prefix.append(prefixWord)
        }
        let attributes = forcedAttributes ?? self.attributes
        if attributes.contains(.duration) {
            let secs = Date().timeIntervalSince1970 - beginTimeStamp.timeIntervalSince1970
            prefix.append("\(secs.stringValue)")
        }
        if attributes.contains(.dateStamp) {
            prefix.append("\(Date().toString(format: "HH:mm:ss"))")
        }

        if attributes.contains(.filename) {
            prefix.append("\(file ?? "")[\(line)])")
        }

        if attributes.contains(.funcName) {
            prefix.append(funcname)
        }

        if attributes.contains(.symbol) {
            prefix.append(level.symbol)
        }

        if attributes.contains(.flag) {
            prefix.append(type.flag)
        }

        if attributes.contains(.status) {
            prefix.append(type.value)
        }

        prefix.append("\(input ?? "")")
        loggingSystem.log(text: prefix.joined(separator: "-"))
    }

    public func logI(
        _ input: Any?,
        _ type: LoggerStatus = .none,
        forcedAttributes: LoggerAttributes? = nil,
        funcname: String = #function,
        filename: String = #file,
        line: Int = #line
    ) {
        log(input, type, .info, forcedAttributes: forcedAttributes, funcname: funcname, filename: filename, line: line)
    }

    public func logE(
        _ input: Any?,
        _ type: LoggerStatus = .none,
        forcedAttributes: LoggerAttributes? = nil,
        funcname: String = #function,
        filename: String = #file,
        line: Int = #line
    ) {
        log(input, type, .error, forcedAttributes: forcedAttributes, funcname: funcname, filename: filename, line: line)
    }

    public func logW(
        _ input: Any?,
        _ type: LoggerStatus = .none,
        forcedAttributes: LoggerAttributes? = nil,
        funcname: String = #function,
        filename: String = #file,
        line: Int = #line
    ) {
        log(input, type, .warning, forcedAttributes: forcedAttributes, funcname: funcname, filename: filename, line: line)
    }

    public func logN(
        _ input: Any?,
        _ type: LoggerStatus = .none,
        forcedAttributes: LoggerAttributes? = nil,
        funcname: String = #function,
        filename: String = #file,
        line: Int = #line
    ) {
        log(input, type, .notice, forcedAttributes: forcedAttributes, funcname: funcname, filename: filename, line: line)
    }
}

private extension TimeInterval {

    var stringValue: String {
        let interval = Int(self)
        let mi = Int((self - Double(interval)) * 1000.0)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d:%03d", hours, minutes, seconds, mi)
    }
}

private extension Date {
    static let formatter = DateFormatter()

    func toString(format: String, timeZone: String = "") -> String {
        Date.formatter.dateFormat = format
        Date.formatter.locale = Locale(identifier: "EN")
        if !timeZone.isEmpty {
            Date.formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        return Date.formatter.string(from: self)
    }
}

public extension String {

    func beautifyURL(_ prefix: String = "##") -> String? {
        if let url = URL(string: self) {
            var result = ""
            result += "Scheme: \(url.scheme ?? "")\n\(prefix)"
            result += "Host: \(url.host ?? "")\n\(prefix)"
            result += "Path: \(url.path)\n\(prefix)"
            if let queryItems = URLComponents(string: self)?.queryItems {
                result += "Query Parameters:\n\(prefix)"
                for queryItem in queryItems {
                    result += "\(queryItem.name): \(queryItem.value ?? "")\n\(prefix)"
                }
            }
            if let fragment = url.fragment {
                result += "Fragment: \(fragment)\n\(prefix)"
            }
            return result
        } else {
            return "Invalid URL"
        }
    }

    func beautifyJSON() -> String? {
        guard let jsonData = data(using: .utf8) else {
            return "Failed to convert JSON string to data."
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let prettyJSON = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let prettyString = String(data: prettyJSON, encoding: .utf8) {
                return prettyString
            } else {
                return "Failed to convert JSON data to string."
            }
        } catch {
            return "Error parsing JSON: \(error)"
        }
    }
}

public struct LogPrefixType {
    public let value: String
    public init(value: String) {
        self.value = "[*\(value)]"
    }
}

public struct LoggerAttributes: OptionSet {
    public let rawValue: Int
    public static let funcName = Self(rawValue: 1 << 0)
    public static let prefix = Self(rawValue: 1 << 1)
    public static let flag = Self(rawValue: 1 << 3)
    public static let status = Self(rawValue: 1 << 4)
    public static let duration = Self(rawValue: 1 << 5)
    public static let dateStamp = Self(rawValue: 1 << 6)
    public static let filename = Self(rawValue: 1 << 7)
    public static let symbol = Self(rawValue: 1 << 8)
    public static let common: Self = [.flag, .prefix, .status]
    public static let commonWithdate: Self = [.flag, .prefix, .status]
    public static let `default`: Self = [.dateStamp, .symbol, .prefix, .flag, .status]
    public static let timestampWithDefault: Self = [.dateStamp, .flag, .prefix, .status, .filename]
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public protocol LoggingSystemType {
    func log(text: String)
}

public struct ConsoleLogger: LoggingSystemType {
    private let logQueue = DispatchQueue(label: "com.logwriter", qos: .background)
    public init() {}
    public func log(text: String) {
        logQueue.async {
            print(text)
        }
    }
}

public enum LoggerStatus: String {
    case none
    case success
    case failure
    public var value: String {
        switch self {
        case .none:
            return ""
        case .success:
            return "success"
        case .failure:
            return "failure"
        }
    }

    public var flag: String {
        switch self {
        case .success: return "📗"
        case .failure: return "📕"
        case .none: return ""
        }
    }
}

public enum LogWriterSettings {
    public static var globalLevel: LogWriter.Levels = .all
}

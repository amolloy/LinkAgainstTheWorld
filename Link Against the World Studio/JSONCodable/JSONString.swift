//
//  JSONString.swift
//  JSONCodable
//
//  Created by Matthew Cheok on 17/7/15.
//  Copyright © 2015 matthewcheok. All rights reserved.
//

import Foundation

public extension JSONEncodable {
    public func toJSONString() throws -> String {
        switch self {
        case let str as String:
            return escapeJSONString(str)
        case is Bool, is Int, is Float, is Double:
            return String(self)
        default:
            let json = try toJSON()
            let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
            guard let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                return ""
            }
            return string as String
        }
    }
}

private func escapeJSONString(_ str: String) -> String {
    var chars = String.CharacterView("\"")
    for c in str.characters {
        switch c {
        case "\\":
            chars.append("\\")
            chars.append("\\")
        case "\"":
            chars.append("\\")
            chars.append("\"")
        default:
            chars.append(c)
        }
    }
    chars.append("\"")
    return String(chars)
}

public extension Optional where Wrapped: JSONEncodable {
    public func toJSONString() throws -> String {
        switch self {
        case let .some(jsonEncodable):
            return try jsonEncodable.toJSONString()
        case nil:
            return "null"
        }
    }
}

public extension JSONDecodable {
    init(JSONString: String) throws {
        guard let data = JSONString.data(using: String.Encoding.utf8) else {
            throw JSONDecodableError.incompatibleTypeError(key: "n/a", elementType: JSONString.dynamicType, expectedType: String.self)
        }
        
        let result: AnyObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))

        guard let converted = result as? [String: AnyObject] else {
            throw JSONDecodableError.dictionaryTypeExpectedError(key: "n/a", elementType: result.dynamicType)
        }
        
        try self.init(object: converted)
    }
}

public extension Array where Element: JSONDecodable {
    init(JSONString: String) throws {
        guard let data = JSONString.data(using: String.Encoding.utf8) else {
            throw JSONDecodableError.incompatibleTypeError(key: "n/a", elementType: JSONString.dynamicType, expectedType: String.self)
        }
        
        let result: AnyObject  = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))

        guard let converted = result as? [AnyObject] else {
            throw JSONDecodableError.arrayTypeExpectedError(key: "n/a", elementType: result.dynamicType)
        }
        
        try self.init(JSONArray: converted)
    }
}

//
//  File.swift
//  
//
//  Created by oem on 09/08/24.
//

import Foundation

public class MatchedCredential: Encodable {
    public var index: Int
    public var fields: [MatchedField]
    
    public init(index: Int, fields: [MatchedField]) {
        self.index = index
        self.fields = fields
    }
    
    enum CodingKeys: String, CodingKey {
        case index, fields
    }
}

public class MatchedField: Encodable {
    public var index: Int
    public var path: MatchedPath
    
    public init(index: Int, path: MatchedPath) {
        self.index = index
        self.path = path
    }
    
    enum CodingKeys: String, CodingKey {
        case index, path
    }
}

public class MatchedPath: Encodable {
    public var path: String?
    public var index: Int
    public var value: Any?
    
    public init(path: String?, index: Int, value: Any?) {
        self.path = path
        self.index = index
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case path, index, value
    }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(path, forKey: .path)
            try container.encode(index, forKey: .index)
            
            if let value = value {
                switch value {
                case let stringValue as String:
                    try container.encode(stringValue, forKey: .value)
                case let intValue as Int:
                    try container.encode(intValue, forKey: .value)
                case let doubleValue as Double:
                    try container.encode(doubleValue, forKey: .value)
                case let boolValue as Bool:
                    try container.encode(boolValue, forKey: .value)
                case let arrayValue as [Any]:
                    var nestedContainer = container.nestedUnkeyedContainer(forKey: .value)
                    for element in arrayValue {
                        if let encodableElement = element as? Encodable {
                            try encodableElement.encode(to: nestedContainer.superEncoder())
                        }
                    }
                case let dictValue as [String: Any]:
                    var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .value)
                    for (key, element) in dictValue {
                        if let encodableElement = element as? Encodable {
                            try encodableElement.encode(to: nestedContainer.superEncoder(forKey: CodingKeys(stringValue: key)!))
                        }
                    }
                default:
                    throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid value type for encoding"))
                }
            }
        }
}


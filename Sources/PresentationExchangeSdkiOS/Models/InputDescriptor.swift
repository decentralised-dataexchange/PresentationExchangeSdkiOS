//
//  PresentationDefinitionModel.swift
//
//
//  Created by milan on 7/8/24.
//
import Foundation
// MARK: - InputDescriptor
public struct InputDescriptor: Codable {
    public var id: String?
    public let name: String?
    public let purpose: String?
    public var constraints: Constraints?
}
// MARK: - Constraints
public struct Constraints: Codable {
    public let limitDisclosure: String?
    public var fields: [Field]?
    enum CodingKeys: String, CodingKey {
        case fields
        case limitDisclosure = "limit_disclosure"
    }
}
// MARK: - Field
public struct Field: Codable, Hashable {
    public let paths: [String]
    public let filter: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case paths = "path"
        case filter
    }

    public init(paths: [String], filter: [String: Any]?) {
        self.paths = paths
        self.filter = filter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        paths = try container.decode([String].self, forKey: .paths)
        let jsonAnyDictionary = try container.decodeIfPresent([String: JSONAny].self, forKey: .filter)
        filter = jsonAnyDictionary?.mapValues { $0.value }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paths, forKey: .paths)
        if let filter = filter {
            let jsonAnyDictionary = filter.mapValues { JSONAny($0) }
            try container.encode(jsonAnyDictionary, forKey: .filter)
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(paths)
        if let filter = filter {
            for (key, value) in filter {
                hasher.combine(key)
                if let value = value as? String {
                    hasher.combine(value)
                }
            }
        }
    }

    public static func == (lhs: Field, rhs: Field) -> Bool {
        return lhs.paths == rhs.paths &&
               NSDictionary(dictionary: lhs.filter ?? [:]).isEqual(to: rhs.filter ?? [:])
    }
}

public struct JSONAny: Codable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let nestedDictionary = try? container.decode([String: JSONAny].self) {
            value = nestedDictionary.mapValues { $0.value }
        } else if let nestedArray = try? container.decode([JSONAny].self) {
            value = nestedArray.map { $0.value }
        } else {
            throw DecodingError.typeMismatch(
                JSONAny.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode JSONAny")
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let dictionaryValue as [String: Any]:
            let wrappedDictionary = dictionaryValue.mapValues { JSONAny($0) }
            try container.encode(wrappedDictionary)
        case let arrayValue as [Any]:
            let wrappedArray = arrayValue.map { JSONAny($0) }
            try container.encode(wrappedArray)
        default:
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unable to encode JSONAny")
            )
        }
    }
}

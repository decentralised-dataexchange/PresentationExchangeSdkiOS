import Foundation
import Sextant
import JSONSchema

/// Match list of credentials against input descriptor and return matched credentials
/// - Parameters:
///   - inputDescriptorJson: JSON string that conforms to presentation exchange specification
///   - credentials: JSON string that is an array of verifiable credentials
/// - Returns: JSON string that contains the matched credentials or an error message
public func matchCredentials(inputDescriptorJson: String, credentials: [String]) throws -> [MatchedCredential] {
    let decoder = JSONDecoder()
    let descriptor = try decoder.decode(InputDescriptor.self, from: Data(inputDescriptorJson.utf8))

    var matches = [MatchedCredential]()

    for (credentialIndex, credential) in credentials.enumerated() {
        var credentialMatched = true
        var matchedFields = [MatchedField]()

        if let fields = descriptor.constraints?.fields {
            for (fieldIndex, field) in fields.enumerated() {
                var fieldMatched = false

                for (pathIndex, path) in field.paths.enumerated() {
                    do {
                        let pathMatches = try applyJsonPath(inputJsonString: credential, path: path)
                        if let firstMatch = pathMatches.first {
                            if let filter = field.filter {
                                let filterData = try JSONSerialization.data(withJSONObject: filter)
                                if let filterString = String(data: filterData, encoding: .utf8) {
                                    try validateJsonSchema(inputJsonString: firstMatch, schema: filter)
                                }
                            }
                            fieldMatched = true
                            matchedFields.append(MatchedField(index: fieldIndex, path: MatchedPath(path: path, index: pathIndex, value: firstMatch)))
                        }
                    } catch {
                        continue
                    }
                }

                if !fieldMatched {
                    if field.optional != true {
                        credentialMatched = false
                    }
                    break
                }
            }
        }

        if credentialMatched {
            matches.append(MatchedCredential(index: credentialIndex, fields: matchedFields))
        }
    }
    return matches
}

// Function to apply JSON path
func applyJsonPath(inputJsonString: String, path: String) throws -> [Any] {
    guard let jsonData = inputJsonString.data(using: .utf8) else {
        throw NSError(domain: "Invalid JSON string", code: 0, userInfo: nil)
    }
    let parsedInput = try JSONSerialization.jsonObject(with: jsonData)
    let parsedJsonPath = try parseJsonPath(path)
    return parsedJsonPath.get(inputJsonString)
}

// Function to validate JSON schema
func validateJsonSchema(inputJsonString: Any, schema: [String: Any]) throws {
    let schemaValidator = try compileJsonSchema(schema: schema)
    try schemaValidator.validate(inputJsonString)
}

// Placeholder functions to simulate JSON path parsing and JSON schema validation.
func parseJsonPath(_ path: String) throws -> SomeJsonPathParser {
    return SomeJsonPathParser(path: path)
}

func compileJsonSchema(schema: [String: Any]) throws -> SomeJsonSchemaValidator {
    return SomeJsonSchemaValidator(schema: schema)
}

// Implementation for JSON path parser
struct SomeJsonPathParser {
    let path: String

    func get(_ json: String) -> [Any] {
        do {
            return try json.query(values: path)?.compactMap({ $0 }) ?? []
        } catch {
            print("JSONPath error: \(error)")
            return []
        }
    }
}

// Implementation for JSON schema validator
struct SomeJsonSchemaValidator {
    let schema: [String: Any]

    func validate(_ json: Any) throws {
        let validationResult = try JSONSchema.validate(json, schema: schema)
        if !validationResult.valid {
            throw ValidationError.validationFailed("Validation failed")
        }
    }
}

enum ValidationError: Error {
    case invalidJson
    case validationFailed(String)  // You can include more details if needed
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Pexioswrapper

/// Match list of credentials against input descriptor and return matched credentials
/// - Parameters:
///   - inputDescriptorJson: Json string that conforms to presentation exchange specification
///   - credentials: Json string that is an array of verifiable credentials
/// - Returns: Json string that contains following fields MatchedCredentials, Err
public func matchCredentials(inputDescriptorJson: String, credentials: [String]) -> String {
    // Convert array of credentials to JSON array
    let jsonData: Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: credentials)
    } catch {
        return "Error: Unable to convert array to JSON data - \(error.localizedDescription)"
    }

    // Convert JSON array to string
    guard let credentialsJsonString = String(data: jsonData, encoding: .utf8) else {
        return "Error: Unable to convert JSON data to string"
    }

    let res = PexioswrapperMatchCredentials(inputDescriptorJson, credentialsJsonString)
    return res
}

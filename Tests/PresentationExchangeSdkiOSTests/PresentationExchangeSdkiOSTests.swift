import XCTest
@testable import PresentationExchangeSdkiOS

class MatchCredentialsTests: XCTestCase {

    func testMatchCredentialsSuccess() {
        let inputDescriptorJson = """
        {
            "id": "test",
            "constraints": {
                "fields": [
                    {
                        "path": ["$.address.city"],
                        "filter": {
                            "type": "string",
                            "enum": ["New York"]
                        }
                    }
                ]
            }
        }
        """
        
        let credentials = [
            """
            {
                "type": ["Passport"],
                "name": "John Doe",
                "dob": "14-Mar-70",
                "address": {
                    "city": "New York",
                    "state": "NY"
                }
            }
            """
        ]

        do {
            let matchedCredentials = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTAssertEqual(matchedCredentials.count, 1, "Expected one matched credential")
            XCTAssertEqual(matchedCredentials.first?.fields.count, 1, "Expected one matched field")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testMatchCredentialsNoMatch() {
        let inputDescriptorJson = """
        {
            "id": "test",
            "constraints": {
                "fields": [
                    {
                        "path": ["$.address.city"],
                        "filter": {
                            "type": "string",
                            "enum": ["Los Angeles"]
                        }
                    }
                ]
            }
        }
        """
        
        let credentials = [
            """
            {
                "type": ["Passport"],
                "name": "John Doe",
                "dob": "14-Mar-70",
                "address": {
                    "city": "New York",
                    "state": "NY"
                }
            }
            """
        ]

        do {
            let matchedCredentials = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTAssertEqual(matchedCredentials.count, 0, "Expected no matched credentials")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testMatchCredentialsInvalidJson() {
        let inputDescriptorJson = """
        {
            "id": "test",
            "constraints": {
                "fields": [
                    {
                        "path": ["$.address.city"]
                    }
                ]
            }
        }
        """
        
        let credentials = [
            """
            {
                "type": ["Passport"],
                "name": "John Doe",
                "dob": "14-Mar-70",
                "address": {
                    "city": "New York",
                    "state": "NY"
                }
            }
            """,
            "Invalid JSON String"
        ]

        do {
            _ = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTFail("Expected function to throw an error for invalid JSON")
        } catch {
            // Expected an error, pass the test
        }
    }
}

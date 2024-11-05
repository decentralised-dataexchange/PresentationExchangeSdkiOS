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
    
    func testMatchCredentialsWithOptionalTrue() {
        let inputDescriptorJson = """
        {
          "id": "abd4acb1-1dcb-41ad-8596-ceb1401a69c7",
          "format": {
            "vc+sd-jwt": {
              "alg": [
                "ES256",
                "ES384"
              ]
            }
          },
          "constraints": {
            "fields": [
              {
                "path": [
                  "$.given_name"
                ]
              },
              {
                "path": [
                  "$.last_name"
                ]
              },
              {
                "path": [
                  "$.vct"
                ],
                "filter": {
                  "type": "string",
                  "const": "VerifiablePortableDocumentA1"
                },
                "optional": true
              }
            ]
          },
          "limit_disclosure": "required"
        }
        """
        
        let credentials = [
            """
            {
              "iss": "https://dss.aegean.gr/rfc-issuer",
              "iat": 1712657569263,
              "given_name": "John",
              "last_name": "Doe"
            }
            """
        ]

        do {
            _ = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTFail("Expected function to throw an error for invalid JSON")
        } catch {
            // Expected an error, pass the test
        }
    }
    
    func testMatchCredentialsWithOptionalFalse() {
        let inputDescriptorJson = """
        {
          "id": "abd4acb1-1dcb-41ad-8596-ceb1401a69c7",
          "format": {
            "vc+sd-jwt": {
              "alg": [
                "ES256",
                "ES384"
              ]
            }
          },
          "constraints": {
            "fields": [
              {
                "path": [
                  "${'$'}.given_name"
                ]
              },
              {
                "path": [
                  "${'$'}.last_name"
                ]
              },
              {
                "path": [
                  "${'$'}.vct"
                ],
                "filter": {
                  "type": "string",
                  "const": "VerifiablePortableDocumentA1"
                },
                "optional": false
              }
            ]
          },
          "limit_disclosure": "required"
        }
        """
        
        let credentials = [
            """
            {
              "iss": "https://dss.aegean.gr/rfc-issuer",
              "iat": 1712657569263,
              "given_name": "John",
              "last_name": "Doe"
            }
            """
        ]

        do {
            _ = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTFail("Expected function to throw an error for invalid JSON")
        } catch {
            // Expected an error, pass the test
        }
    }
    
    func testMatchCredentialsWithNoOptional() {
        let inputDescriptorJson = """
        {
          "id": "abd4acb1-1dcb-41ad-8596-ceb1401a69c7",
          "format": {
            "vc+sd-jwt": {
              "alg": [
                "ES256",
                "ES384"
              ]
            }
          },
          "constraints": {
            "fields": [
              {
                "path": [
                  "${'$'}.given_name"
                ]
              },
              {
                "path": [
                  "${'$'}.last_name"
                ]
              },
              {
                "path": [
                  "${'$'}.vct"
                ],
                "filter": {
                  "type": "string",
                  "const": "VerifiablePortableDocumentA1"
                }
              }
            ]
          },
          "limit_disclosure": "required"
        }
        """
        
        let credentials = [
            """
            {
              "iss": "https://dss.aegean.gr/rfc-issuer",
              "iat": 1712657569263,
              "given_name": "John",
              "last_name": "Doe"
            }
            """
        ]

        do {
            _ = try matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
            XCTFail("Expected function to throw an error for invalid JSON")
        } catch {
            // Expected an error, pass the test
        }
    }
}

<h1 align="center">
    Presentation Exchange SDK (iOS)
</h1>

<p align="center">
    <a href="/../../commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/decentralised-dataexchange/PresentationExchangeSdkiOS?style=flat"></a>
    <a href="/../../issues" title="Open Issues"><img src="https://img.shields.io/github/issues/decentralised-dataexchange/PresentationExchangeSdkiOS?style=flat"></a>
    <a href="./LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-yellowgreen?style=flat"></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#licensing">Licensing</a>
</p>


## About

This repository hosts source code for presentation exchange SDK.

## Usage

1. Add the dependency to the `dependencies` value of your `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/decentralised-dataexchange/PresentationExchangeSdkiOS.git", .upToNextMajor(from: "2024.3.1"))
]
```

2. Example usage of the SDK:

```swift
import PresentationExchangeSdkiOS
let inputDescriptorJson = """
{"id":"9a18d1b5-13ac-4fbc-8c12-d5916740ce1d","constraints":{"fields":[{"path":["$.type"],"filter":{"type":"array","contains":{"const":"Passport"}}},{"path":["$.name"],"filter":{"type":"string","const":"John"}},{"path":["$.dob"],"filter":{"type":"string","const":"14-Mar-70"}},{"path":["$.address.city"],"filter":{"type":"string","const":"EKM"}}]}}
"""
let credentials = ["""
{"type":["Passport"],"name":"John","dob":"14-Mar-70","address":{"city":"EKM","state":"Kerala"}}
"""]
let res = matchCredentials(inputDescriptorJson: inputDescriptorJson, credentials: credentials)
print(res)
```

Will output:

```json
{
  "MatchedCredentials": [
    {
      "index": 0,
      "fields": [
        {
          "index": 0,
          "path": {
            "path": "$.type",
            "index": 0,
            "value": [
              "Passport"
            ]
          }
        },
        {
          "index": 1,
          "path": {
            "path": "$.name",
            "index": 0,
            "value": "John"
          }
        },
        {
          "index": 2,
          "path": {
            "path": "$.dob",
            "index": 0,
            "value": "14-Mar-70"
          }
        },
        {
          "index": 3,
          "path": {
            "path": "$.address.city",
            "index": 0,
            "value": "EKM"
          }
        }
      ]
    }
  ],
  "Err": ""
}
```

## Contributing

Feel free to improve the plugin and send us a pull request. If you find any problems, please create an issue in this repo.

## Licensing
Copyright (c) 2023-25 LCubed AB (iGrant.io), Sweden

Licensed under the Apache 2.0 License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the LICENSE for the specific language governing permissions and limitations under the License.
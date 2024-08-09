// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationExchangeSdkiOS",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PresentationExchangeSdkiOS",
            targets: ["PresentationExchangeSdkiOS"]),
    ],
    dependencies: [
      .package(
        url: "https://github.com/KittyMac/Sextant.git",
        .upToNextMinor(from: "0.4.0")
      ),
      .package(
        url: "https://github.com/kylef/JSONSchema.swift",
        from: "0.6.0"
      )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PresentationExchangeSdkiOS",
            dependencies: [
              .product(
                name: "Sextant",
                package: "Sextant"
              ),
              .product(
                name: "JSONSchema",
                package: "JSONSchema.swift"
              ),
            ]),
        .testTarget(
            name: "PresentationExchangeSdkiOSTests",
            dependencies: ["PresentationExchangeSdkiOS",
                           .product(
                             name: "Sextant",
                             package: "Sextant"
                           ),
                           .product(
                             name: "JSONSchema",
                             package: "JSONSchema.swift"
                           )]),
    ])

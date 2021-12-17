// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "Txtool",
        platforms: [.macOS(.v12), .iOS(.v15), .macCatalyst(.v15), .watchOS(.v8), .tvOS(.v15)],
        products: [
                .executable(name: "txtool", targets: ["Txtool"])
        ],
        dependencies: [
                .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.2")
        ],
        targets: [
                .executableTarget(
                        name: "Txtool",
                        dependencies: [
                                .product(name: "ArgumentParser", package: "swift-argument-parser")
                        ]
                ),
                .testTarget(name: "TxtoolTests", dependencies: ["Txtool"])
        ]
)

// swift-tools-version:5.7

import PackageDescription

let package = Package(
        name: "Txtool",
        platforms: [.macOS(.v13)],
        products: [
                .executable(name: "txtool", targets: ["Txtool"])
        ],
        dependencies: [
                .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.1")
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

// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tdscli2",
    platforms: [
        .macOS(.v26)
    ],
    dependencies: [
        .package(url: "https://github.com/oliwonders/FreeTDSKit.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "tdscli2",
            dependencies: [
                .product(name: "FreeTDSKit", package: "FreeTDSKit")
            ],
            resources: [.copy("Config.plist")]
        )
    ]
)

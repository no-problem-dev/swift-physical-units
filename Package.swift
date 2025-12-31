// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PhysicalUnits",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "PhysicalUnits",
            targets: ["PhysicalUnits"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "PhysicalUnits",
            dependencies: [],
            path: "Sources/PhysicalUnits"
        ),
        .testTarget(
            name: "PhysicalUnitsTests",
            dependencies: ["PhysicalUnits"],
            path: "Tests/PhysicalUnitsTests"
        )
    ]
)

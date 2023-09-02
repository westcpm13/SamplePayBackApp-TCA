// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transactions",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Transactions",
            targets: ["Transactions"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/ashleymills/Reachability.swift",
            from: "5.1.0"
        )
    ],
    targets: [
        .target(
            name: "Transactions",
            dependencies: [
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ],
            resources: [.process("Transactions/Model/PBTransactions.json")]),
        .testTarget(
            name: "TransactionsTests",
            dependencies: ["Transactions"]),
    ]
)




// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSpace",
    platforms: [
        .macOS(.v14), .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DesignSpace",
            targets: ["DesignSpace"]),
        
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
      
        //.package(url: "https://github.com/typoland/HyperSpace", branch: "main"),
        .package(path: "../HyperSpace"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMinor(from: "1.1.0"))
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DesignSpace", 
            dependencies: ["HyperSpace",
                           .product(name: "Collections", package: "swift-collections")],
            resources: [.process("AxisNames.json")]
        ),
        .testTarget(
            name: "DesignSpaceTests",
            dependencies: ["DesignSpace"]
        ),
        
        
    ]
)

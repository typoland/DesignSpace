
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
      
        .package(name: "HyperSpace",
                 path: "/Users/lukasz/Documents/XCode/NewHyperValuePackages/HyperSpace/"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DesignSpace", 
            dependencies: ["HyperSpace"]),
        .testTarget(
            name: "DesignSpaceTests",
            dependencies: ["DesignSpace"]),
        
        
    ]
)

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WDSelectAlertView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WDSelectAlertView",
            targets: ["WDSelectAlertView"]
        )
    ],
    targets: [
        .target(
            name: "WDSelectAlertView",
            path: "WDSelectAlertView/Classes",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Controller"),
                .headerSearchPath("Model"),
                .headerSearchPath("View"),
                .headerSearchPath("Tool")
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreGraphics")
            ]
        )
    ]
)

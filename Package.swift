// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "mixnmatch",
    platforms: [
        .iOS("16")
    ],
    products: [
        .iOSApplication(
            name: "mixnmatch",
            targets: ["AppModule"],
            bundleIdentifier: "com.mrezkys.mixnmatch",
            teamIdentifier: "5LSQ3C9W8U",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .cat),
            accentColor: .presetColor(.purple),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .fileAccess(.pictureFolder, mode: .readWrite),
                .fileAccess(.userSelectedFiles, mode: .readWrite),
                .camera(purposeString: "Take outfit picture")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
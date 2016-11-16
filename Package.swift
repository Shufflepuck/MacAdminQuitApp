import PackageDescription

let package = Package(
    name: "MacAdminQuitApp",
    dependencies: [
        .Package(url: "https://github.com/ftiff/FTApp", majorVersion: 0, minor: 3),
    ],
    exclude: ["images"]
)

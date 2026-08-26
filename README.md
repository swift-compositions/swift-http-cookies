# swift-http-cookies

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

HTTP cookie parsing and serialization for Swift.

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-http-cookies.git", branch: "main")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "HTTP Cookies", package: "swift-http-cookies")
    ]
)
```

## Error Handling

Encoding failures surface as `HTTPCookies.EncodingPolicy.Error`, thrown from the
encoding-policy surface. The error type is declared by this package, so callers
can exhaustively switch over it rather than matching on a general error protocol.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).

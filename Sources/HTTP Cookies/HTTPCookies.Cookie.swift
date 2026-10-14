extension HTTPCookies {
    public struct Cookie: Sendable, Hashable {
        public var name: String
        public var value: Value

        public init(name: String, value: Value) {
            self.name = name
            self.value = value
        }

    }
}

extension HTTPCookies.Cookie {
    public func headerValue(
        using policy: HTTPCookies.EncodingPolicy = .raw
    ) throws(HTTPCookies.EncodingPolicy.Error) -> String {
        "\(name)=\(try value.encoded(using: policy))"
    }
}

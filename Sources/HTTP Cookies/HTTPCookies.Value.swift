extension HTTPCookies {
    public struct Value: Sendable, Hashable {
        public var string: String

        public init(string: String) {
            self.string = string
        }

        public init(token: String) {
            self.init(string: token)
        }

    }
}

extension HTTPCookies.Value {
    public func encoded(
        using policy: HTTPCookies.EncodingPolicy = .raw
    ) throws(HTTPCookies.EncodingPolicy.Error) -> String {
        try policy.encode(string)
    }

    public func decoded(
        using policy: HTTPCookies.EncodingPolicy = .raw
    ) throws(HTTPCookies.EncodingPolicy.Error) -> Self {
        Self(string: try policy.decode(string))
    }
}

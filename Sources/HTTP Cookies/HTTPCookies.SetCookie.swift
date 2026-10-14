extension HTTPCookies {
    public struct SetCookie: Sendable, Hashable {
        public var cookie: Cookie
        public var configuration: Configuration

        public init(cookie: Cookie, configuration: Configuration = .init()) {
            self.cookie = cookie
            self.configuration = configuration
        }

        public init(name: String, value: Value, configuration: Configuration = .init()) {
            self.init(cookie: .init(name: name, value: value), configuration: configuration)
        }

    }
}

extension HTTPCookies.SetCookie {
    public func headerValue(
        using policy: HTTPCookies.EncodingPolicy = .raw
    ) throws(HTTPCookies.EncodingPolicy.Error) -> String {
        [
            try cookie.headerValue(using: policy),
            configuration.expires.map { "Expires=\($0)" },
            configuration.maxAge.map { "Max-Age=\($0)" },
            configuration.domain.map { "Domain=\($0)" },
            configuration.path.map { "Path=\($0)" },
            configuration.isSecure ? "Secure" : nil,
            configuration.isHTTPOnly ? "HttpOnly" : nil,
            configuration.sameSitePolicy.map {
                switch $0 {
                case .strict: "SameSite=Strict"
                case .lax: "SameSite=Lax"
                case .none: "SameSite=None"
                }
            },
        ].compactMap { $0 }.joined(separator: "; ")
    }
}

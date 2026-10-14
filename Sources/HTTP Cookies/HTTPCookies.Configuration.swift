extension HTTPCookies {
    public struct Configuration: Sendable, Hashable {
        public var expires: String?
        public var maxAge: Int?
        public var domain: String?
        public var path: String?
        public var isSecure: Bool
        public var isHTTPOnly: Bool
        public var sameSitePolicy: SameSitePolicy?

        public init(
            expires: String? = nil,
            maxAge: Int? = nil,
            domain: String? = nil,
            path: String? = nil,
            isSecure: Bool = true,
            isHTTPOnly: Bool = true,
            sameSitePolicy: SameSitePolicy? = .lax
        ) {
            self.expires = expires
            self.maxAge = maxAge
            self.domain = domain
            self.path = path
            self.isSecure = isSecure
            self.isHTTPOnly = isHTTPOnly
            self.sameSitePolicy = sameSitePolicy
        }
    }
}

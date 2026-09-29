import Testing

@testable import HTTP_Cookies

@Suite
struct `Cookie encoding boundaries` {
    @Test
    func `an empty raw value serializes as an empty pair value`() throws(HTTPCookies.EncodingPolicy.Error) {
        #expect(try HTTPCookies.Cookie(name: "a", value: .init(string: "")).headerValue() == "a=")
    }

    @Test(arguments: ["!", "#", "+", "-", ":", "<", "[", "]", "~"])
    func `raw policy accepts the edges of the cookie octet ranges`(value: String) throws(HTTPCookies.EncodingPolicy.Error) {
        #expect(try HTTPCookies.Value(string: value).encoded() == value)
    }

    @Test(arguments: [" ", "\"", ",", "\\", "\u{7F}", "✓"])
    func `raw policy rejects characters outside the cookie octets`(value: String) {
        #expect(throws: HTTPCookies.EncodingPolicy.Error.invalidCharacter(Character(value))) {
            try HTTPCookies.Value(string: value).encoded()
        }
    }

    @Test(arguments: ["%", "%4", "%GG", "a%"])
    func `percent decoding rejects malformed escapes`(value: String) {
        #expect(throws: HTTPCookies.EncodingPolicy.Error.malformedPercentEscape) {
            try HTTPCookies.Value(string: value).decoded(using: .percentEncoded)
        }
    }

    @Test
    func `percent decoding rejects bytes that are not UTF-8`() {
        #expect(throws: HTTPCookies.EncodingPolicy.Error.invalidUTF8) {
            try HTTPCookies.Value(string: "%FF").decoded(using: .percentEncoded)
        }
    }

    @Test
    func `percent decoding accepts lowercase hex digits`() throws(HTTPCookies.EncodingPolicy.Error) {
        #expect(try HTTPCookies.Value(string: "%e2%9c%93").decoded(using: .percentEncoded).string == "✓")
    }

    @Test(arguments: ["100%", "%41", "%%"])
    func `percent encoding round trips values containing a percent sign`(value: String) throws(HTTPCookies.EncodingPolicy.Error) {
        let encoded = try HTTPCookies.Value(string: value).encoded(using: .percentEncoded)

        #expect(try HTTPCookies.Value(string: encoded).decoded(using: .percentEncoded).string == value)
    }
}

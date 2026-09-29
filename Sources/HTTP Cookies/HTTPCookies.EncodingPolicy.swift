extension HTTPCookies {
    /// The policy used when a cookie value is serialized into a header field.
    public enum EncodingPolicy: Sendable, Hashable {
        /// Require the value to already be a valid RFC 6265 cookie value.
        case raw

        /// Percent-encode bytes that are not valid raw cookie-octets.
        case percentEncoded
    }
}

extension HTTPCookies.EncodingPolicy {
    /// Errors produced while encoding a cookie value.
    public enum Error: Swift.Error, Sendable, Hashable {
        case invalidCharacter(Character)
        case malformedPercentEscape
        case invalidUTF8
    }
}

extension HTTPCookies.EncodingPolicy {
    func encode(_ value: String) throws(Error) -> String {
        switch self {
        case .raw:
            for character in value {
                guard Self.isCookieOctet(character) else {
                    throw .invalidCharacter(character)
                }
            }
            return value

        case .percentEncoded:
            return value.utf8.reduce(into: "") { result, byte in
                if byte != 0x25, Self.isCookieOctet(byte) {
                    result.append(Character(UnicodeScalar(byte)))
                } else {
                    result.append("%")
                    result.append(Self.hex(byte >> 4))
                    result.append(Self.hex(byte & 0x0F))
                }
            }
        }
    }

    func decode(_ value: String) throws(Error) -> String {
        guard self == .percentEncoded else { return value }
        var bytes: [UInt8] = []
        var iterator = value.utf8.makeIterator()
        while let byte = iterator.next() {
            guard byte == 37 else {
                bytes.append(byte)
                continue
            }
            guard let high = iterator.next(), let low = iterator.next(), let high = Self.hex(high),
                let low = Self.hex(low)
            else { throw .malformedPercentEscape }
            bytes.append(high << 4 | low)
        }
        let decoded = String(decoding: bytes, as: UTF8.self)
        guard Array(decoded.utf8) == bytes else { throw .invalidUTF8 }
        return decoded
    }

    private static func isCookieOctet(_ byte: UInt8) -> Bool {
        byte == 0x21 || 0x23...0x2B ~= byte || 0x2D...0x3A ~= byte || 0x3C...0x5B ~= byte
            || 0x5D...0x7E ~= byte
    }

    private static func isCookieOctet(_ character: Character) -> Bool {
        guard character.utf8.count == 1, let byte = character.utf8.first else { return false }
        return isCookieOctet(byte)
    }

    private static func hex(_ value: UInt8) -> Character {
        "0123456789ABCDEF"[
            "0123456789ABCDEF".index("0123456789ABCDEF".startIndex, offsetBy: Int(value))
        ]
    }

    private static func hex(_ value: UInt8) -> UInt8? {
        switch value {
        case 48...57: return value - 48
        case 65...70: return value - 55
        case 97...102: return value - 87
        default: return nil
        }
    }
}

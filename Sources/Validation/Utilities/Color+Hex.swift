import SwiftUI

extension Color {
    static func accentFromHexCode(_ hex: String?) -> Color {
        if let hex {
            Color(hex: hex)
        } else {
            .accentColor
        }
    }
    
    /// Create a color from a hex integer
    /// - Parameter hex: `0xff00ee` Must be 6 in length after the 0x prefix
    ///
    /// ```swift
    ///     Color(hex: 12345) // BAD!
    ///     Color(hex: 0x1) // BAD!
    ///     Color(hex: 0xffff23) // GOOD!
    /// ```
    init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B)
    }
    
    /// Create a color from a hex code
    ///
    /// Converts a hex code to an integer and then creates a Color with RGB values.
    ///
    /// - Parameter hex: A hex code - Must be 3 or 6 characters in length (not including the #)
    ///
    /// ```swift
    ///     Color(hex: "ffffff") // GOOD!
    ///     Color(hex: "#ffffff") // GOOD!
    /// ```
    init(hex: String) {
        self.init(
            hex: hex.threeToSix().asHexadecimalInteger()
        )
    }
}

extension String {
    
    /// Converts a string into a hexadecimal integer
    /// - Returns: Int : 0xff4433
    ///
    /// If you receive a 0 back, that means the string could not convert into a hexadecimal integer
    func asHexadecimalInteger() -> Int {
        var hexadecimal: UInt64 = 0
        Scanner(string: self).scanHexInt64(&hexadecimal)
        return Int(hexadecimal)
    }
    
    /// In the event that a hex code is optimized to be a 3 digit shorthand, duplicate each value
    ///
    ///  - Important: This assumes the string is a 3 or 6 digit hex code
    ///
    /// - Returns: A potentially modified string
    func threeToSix() -> String {
        let value = self.replacingOccurrences(of: "#", with: "")
        if value.count == 3 {
            var result = ""
            for character in value {
                result.append("\(character)")
                result.append("\(character)")
            }
            return result
        }
        return value
    }
}


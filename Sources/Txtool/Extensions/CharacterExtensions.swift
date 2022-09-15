extension Character {

        /// UNICODE code points. Example: é = ["U+65", "U+301"]
        var codePoints: [String] {
                return self.unicodeScalars.map { "U+" + String($0.value, radix: 16, uppercase: true) }
        }

        /// UNICODE code points as a String. Example: é = "U+65 U+301"
        var codePointsText: String {
                return self.codePoints.joined(separator: " ")
        }

        /// Create a Character from the given Unicode Code Point String (U+XXXX)
        init?(codePoint: String) {
                let cropped = codePoint.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "U+", with: "", options: [.anchored, .caseInsensitive])
                guard let u32 = UInt32(cropped, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                self.init(scalar)
        }


        /// UNICODE code point as decimal code
        var decimalCode: Int? {
                guard let scalar = self.unicodeScalars.first else { return nil }
                let number = Int(scalar.value)
                return number
        }

        /// Create a Character from the given Unicode code point (decimal)
        init?(decimal: Int) {
                guard let scalar = Unicode.Scalar(decimal) else { return nil }
                self.init(scalar)
        }


        /// a-z or A-Z
        var isBasicLatinLetter: Bool {
                return ("a"..."z") ~= self || ("A"..."Z") ~= self
        }
}

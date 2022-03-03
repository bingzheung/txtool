import ArgumentParser

extension Character {

        /// UNICODE code points. Example: Á = ["U+41", "U+301"]
        var codePoints: [String] {
                return self.unicodeScalars.map { "U+" + String($0.value, radix: 16, uppercase: true) }
        }

        /// UNICODE code points as a String. Example: Á = "U+41 U+301"
        var codePointsText: String {
                return self.codePoints.joined(separator: " ")
        }

        /// Create a Character from the given Unicode Code Point String (U+XXXX)
        init?(codePoint: String) {
                let cropped = codePoint.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(2)
                guard let u32 = UInt32(cropped, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                self.init(scalar)
        }
}

extension Txtool {

        struct Codepoint: ParsableCommand {

                static let configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "codepoint",
                        abstract: "Unicode code point",
                        discussion: "Get Unicode code point of input character"
                )

                @Argument(help: "The text you want to search")
                var text: String

                func run() throws {
                        guard !text.isEmpty else { return }
                        var output: String = ""
                        for character in text {
                                let codepoint: String = character.codePointsText
                                let item: String = "\(codepoint)# { \(character) }\n"
                                output += item
                        }
                        print(output)
                }
        }
}

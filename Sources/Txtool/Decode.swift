import ArgumentParser

extension Txtool {

        struct Decode: ParsableCommand {

                static let configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "decode",
                        abstract: "Decode Unicode code point as character",
                        discussion: "Output character of Unicode code point"
                )

                @Argument(help: "The Unicode code point you want to decode")
                var code: String

                func run() throws {
                        guard !code.isEmpty else { return }
                        guard let character = Character(codePoint: code) else {
                                print("Failed to decode { \(code) }.")
                                return
                        }
                        print("{ \(character) }\n")
                }
        }
}

import ArgumentParser

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

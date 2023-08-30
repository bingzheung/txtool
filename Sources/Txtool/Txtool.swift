import Foundation
import ArgumentParser

struct Txtool: ParsableCommand {

        static let configuration: CommandConfiguration = CommandConfiguration(
                commandName: "txtool",
                abstract: "Text Tool",
                discussion: "A tool to handle texts",
                version: "0.1.0",
                subcommands: [Codepoint.self, Decode.self, Unique.self, Sort.self, Reverse.self, AddText.self]
        )
}

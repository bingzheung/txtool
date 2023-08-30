import Foundation
import ArgumentParser

extension Txtool {

        struct AddText: ParsableCommand {

                static let configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "addtext",
                        abstract: "Add Text",
                        discussion: "Add text to the begin or end of each line"
                )

                @Option(name: .long, help: "The text to be add to the begin.")
                var begin: String?

                @Option(name: .long, help: "The text to be add to the end.")
                var end: String?

                @Option(name: .long, help: "The text to be add to both sides.")
                var both: String?

                @Option(name: .shortAndLong, help: "The input file path.")
                var input: String

                @Option(name: .shortAndLong, help: "The output file path.")
                var output: String

                func run() throws {
                        guard FileManager.default.fileExists(atPath: input) else {
                                throw AddTextError.inputFileNotFound
                        }
                        guard !(FileManager.default.fileExists(atPath: output)) else {
                                throw AddTextError.outputFileAlreadyExists
                        }

                        let sourceUrl: URL = URL(fileURLWithPath: input)
                        let destinationUrl: URL = URL(fileURLWithPath: output, isDirectory: false)

                        guard let readContent: String = try? String(contentsOf: sourceUrl) else {
                                throw AddTextError.readInputFileFailed
                        }
                        let rawContent: String = readContent.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !(rawContent.isEmpty) else {
                                throw AddTextError.inputFileIsEmpty
                        }
                        let sourceLines: [String] = rawContent.components(separatedBy: .newlines)
                        let transformed: [String] = sourceLines.map { line -> String in
                                return line.isEmpty ? line : add(origin: line)
                        }
                        let product: String = transformed.joined(separator: "\n") + "\n"
                        do {
                                try product.write(to: destinationUrl, atomically: true, encoding: .utf8)
                        } catch {
                                fatalError(error.localizedDescription)
                        }
                }

                private func add(origin: String) -> String {
                        switch (both, begin, end) {
                        case (.some(let text), _, _):
                                return text + origin + text
                        case (.none, .some(let beginText), .some(let endText)):
                                return beginText + origin + endText
                        case (.none, .some(let beginText), .none):
                                return beginText + origin
                        case (.none, .none, .some(let endText)):
                                return origin + endText
                        default:
                                return origin
                        }
                }

                enum AddTextError: String, Error {
                        case inputFileNotFound = "Input file not found."
                        case outputFileAlreadyExists = "Output file already exists."
                        case inputFileIsEmpty = "Input file is empty."
                        case createOutputFileFailed = "Failed to create output file."
                        case readInputFileFailed = "Failed to read input file."
                }
        }
}

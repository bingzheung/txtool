import Foundation
import ArgumentParser

extension Txtool {

        struct Unique: ParsableCommand {

                static let configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "unique",
                        abstract: "Unique lines",
                        discussion: "Deduplicate lines"
                )

                @Option(name: .shortAndLong, help: "The input file path.")
                var input: String

                @Option(name: .shortAndLong, help: "The output file path.")
                var output: String

                func run() throws {
                        guard FileManager.default.fileExists(atPath: input) else {
                                throw UniqueError.inputFileNotFound
                        }
                        guard !(FileManager.default.fileExists(atPath: output)) else {
                                throw UniqueError.outputFileAlreadyExists
                        }

                        let sourceUrl: URL = URL(fileURLWithPath: input)
                        let destinationUrl: URL = URL(fileURLWithPath: output, isDirectory: false)

                        guard let readContent: String = try? String(contentsOf: sourceUrl) else {
                                throw UniqueError.readInputFileFailed
                        }

                        let rawContent: String = readContent.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
                        guard !(rawContent.isEmpty) else { throw UniqueError.inputFileIsEmpty }

                        let sourceLines: [String] = rawContent
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter({ !$0.isEmpty })

                        let uniquedLines: [String] = sourceLines.uniqued()
                        let product: String = uniquedLines.joined(separator: "\n")

                        do {
                                try product.write(to: destinationUrl, atomically: true, encoding: .utf8)
                        } catch {
                                fatalError("\(error.localizedDescription)")
                        }
                }

                enum UniqueError: String, Error {
                        case inputFileNotFound = "Input file not found."
                        case outputFileAlreadyExists = "Output file already exists."
                        case createOutputFileFailed = "Failed to create output file."
                        case readInputFileFailed = "Failed to read input file."
                        case inputFileIsEmpty = "Input file is empty."
                }
        }
}

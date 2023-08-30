import Foundation
import ArgumentParser

extension Txtool {

        struct Reverse: ParsableCommand {

                static let configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "reverse",
                        abstract: "Reverse lines",
                        discussion: "Reverse top-bottom"
                )

                @Option(name: .shortAndLong, help: "The input file path.")
                var input: String

                @Option(name: .shortAndLong, help: "The output file path.")
                var output: String

                func run() throws {
                        guard FileManager.default.fileExists(atPath: input) else {
                                throw TxtoolError.inputFileNotFound
                        }
                        guard !(FileManager.default.fileExists(atPath: output)) else {
                                throw TxtoolError.outputFileAlreadyExists
                        }

                        let sourceUrl: URL = URL(fileURLWithPath: input)
                        let destinationUrl: URL = URL(fileURLWithPath: output, isDirectory: false)

                        guard let readContent: String = try? String(contentsOf: sourceUrl) else {
                                throw TxtoolError.readInputFileFailed
                        }

                        let rawContent: String = readContent.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
                        guard !(rawContent.isEmpty) else { throw TxtoolError.inputFileIsEmpty }

                        let sourceLines: [String] = rawContent
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter({ !$0.isEmpty })
                        guard !(sourceLines.isEmpty) else { throw TxtoolError.inputFileIsEmpty }

                        let reveredLines = sourceLines.reversed()
                        let product: String = reveredLines.joined(separator: "\n") + "\n"

                        do {
                                try product.write(to: destinationUrl, atomically: true, encoding: .utf8)
                        } catch {
                                fatalError("\(error.localizedDescription)")
                        }
                }
        }
}

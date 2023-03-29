import Foundation
import ArgumentParser

extension Txtool {

        struct Sort: ParsableCommand {

                static var configuration: CommandConfiguration = CommandConfiguration(
                        commandName: "sort",
                        abstract: "Sort lines, dict",
                        discussion: "Sort lines, dict"
                )

                enum SortError: String, Error {
                        case missingInputFile = "Missing input file name."
                        case tooMuchInputFiles = "Too much input files."
                }

                @Option(name: .long, help: "lines file name to be sort")
                var lines: String?

                @Option(name: .long, help: "dict file name to be sort")
                var dict: String?

                @Option(name: .shortAndLong, help: "destination file name")
                var destination: String?

                private var destinationUrl: URL? {
                        guard let path: String = destination else { return nil }
                        return URL(fileURLWithPath: path, isDirectory: false)
                }

                func run() throws {
                        switch (lines, dict) {
                        case (.none, .none):
                                throw SortError.missingInputFile
                        case (.some, .none):
                                let sourceUrl: URL = accessUrl(input: lines)
                                sortLines(source: sourceUrl, destination: destinationUrl)
                        case (.none, .some):
                                let sourceUrl: URL = accessUrl(input: dict)
                                sortDict(source: sourceUrl, destination: destinationUrl)
                        case (.some, .some):
                                throw SortError.tooMuchInputFiles
                        }
                }


                // MARK: - Methods

                private func accessUrl(input: String?) -> URL {
                        guard let path: String = input else {
                                fatalError("Wrong input file path.")
                        }
                        let sourceUrl: URL = URL(fileURLWithPath: path, isDirectory: false)
                        guard FileManager.default.fileExists(atPath: path) else {
                                fatalError("File not exists at: \(path)")
                        }
                        return sourceUrl
                }

                private func sortLines(source: URL, destination: URL? = nil) {
                        guard let sourceContent: String = try? String(contentsOf: source) else {
                                fatalError("Can not read content from source file. Source URL: \(source)")
                        }
                        let sourceLines: [String] = sourceContent
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .trimmingCharacters(in: .controlCharacters)
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter({ !$0.isEmpty })
                                .uniqued()

                        let sortedLines: [String] = sourceLines.sortedByUnicode()
                        let product: String = sortedLines.joined(separator: "\n")

                        let destinationUrl: URL = destination ?? source.deletingLastPathComponent().appendingPathComponent("lines-sorted.txt", isDirectory: false)
                        do {
                                try product.write(to: destinationUrl, atomically: true, encoding: .utf8)
                        } catch {
                                print(error.localizedDescription)
                        }
                }

                private func sortDict(source: URL, destination: URL? = nil) {

                        /// Split text to two parts
                        /// - Parameter text: text to split
                        /// - Returns: First: Cantonese characters, Second: Romanization.
                        func parts(of text: String) -> (first: String, second: String) {
                                let parts: [String] = text.components(separatedBy: "\t")
                                let firstPart: String = parts.first ?? "XFIRSTX"
                                let secondPart: String = parts.count > 1 ? parts[1] : "XSECONDX"
                                return (firstPart, secondPart)
                        }

                        func compareTexts(lhs: String, rhs: String) -> ComparisonResult {
                                let both: [String] = [lhs, rhs]
                                let sorted: [String] = both.sortedByUnicode()
                                if sorted[0] == both[0] {
                                        return .orderedAscending
                                } else {
                                        return .orderedDescending
                                }
                        }

                        guard let sourceContent: String = try? String(contentsOf: source) else {
                                fatalError("Can not read content from source file. Source URL: \(source)")
                        }
                        let sourceLines: [String] = sourceContent
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .trimmingCharacters(in: .controlCharacters)
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter({ !$0.isEmpty })
                                .uniqued()

                        let englishLocale: Locale = Locale(identifier: "en")

                        let sortedLines: [String] = sourceLines.sorted { lhs, rhs in
                                let lhsComponents = parts(of: lhs)
                                let rhsComponents = parts(of: rhs)
                                let alphabetCompare = lhsComponents.second.compare(rhsComponents.second, locale: englishLocale)
                                if alphabetCompare == .orderedSame {
                                        let compared = compareTexts(lhs: lhsComponents.first, rhs: rhsComponents.first)
                                        return compared == .orderedAscending
                                } else {
                                        return alphabetCompare == .orderedAscending
                                }
                        }
                        let product: String = sortedLines.joined(separator: "\n")

                        let destinationUrl: URL = destination ?? source.deletingLastPathComponent().appendingPathComponent("dict-sorted.txt", isDirectory: false)
                        do {
                                try product.write(to: destinationUrl, atomically: true, encoding: .utf8)
                        } catch {
                                print(error.localizedDescription)
                        }
                }
        }
}

extension Array where Element == String {

        func sortedByUnicode() -> [Element] {
                return self.sorted(by: { (lhs, rhs) -> Bool in
                        let lhsCodes: [UInt32] = lhs.map({ $0.unicodeScalars.first?.value ?? 0 })
                        let rhsCodes: [UInt32] = rhs.map({ $0.unicodeScalars.first?.value ?? 0 })
                        let lhsCount: Int = lhsCodes.count
                        let rhsCount: Int = rhsCodes.count
                        guard (lhsCount > 0) && (lhsCount > 0) else { return lhsCount < rhsCount }
                        if lhs == rhs {
                                return false
                        } else if lhs.hasPrefix(rhs) {
                                return false
                        } else if rhs.hasPrefix(lhs) {
                                return true
                        }
                        let minLength: Int = Swift.min(lhsCount, rhsCount)
                        var isAscending: Bool = false
                        for index in 0..<minLength {
                                if lhsCodes[index] < rhsCodes[index] {
                                        isAscending = true
                                        break
                                } else if lhsCodes[index] > rhsCodes[index] {
                                        isAscending = false
                                        break
                                } else {
                                        isAscending = false
                                }
                        }
                        return isAscending
                })
        }
}

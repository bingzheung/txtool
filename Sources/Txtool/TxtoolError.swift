enum TxtoolError: String, Error {
        case inputFileNotFound = "Input file not found."
        case outputFileAlreadyExists = "Output file already exists."
        case createOutputFileFailed = "Failed to create output file."
        case readInputFileFailed = "Failed to read input file."
        case inputFileIsEmpty = "Input file is empty."
}

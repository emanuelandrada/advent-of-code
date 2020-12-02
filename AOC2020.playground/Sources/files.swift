import Foundation

public func readLines(_ fileName: String) -> [Substring] {
    let url = Bundle.main.url(forResource: fileName, withExtension: "txt")!
    let content = try! String(contentsOf: url, encoding: .utf8)
    return content.split { $0.isNewline }
}

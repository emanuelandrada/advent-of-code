import Foundation

struct TextFile: Sequence, IteratorProtocol {

    init(_ path: String) {
        freopen(path, "r", stdin)
    }
    func next() -> String? {
        readLine(strippingNewline: true)
    }
}

func readLines(_ fileName: String) -> TextFile {
    TextFile(Bundle.main.path(forResource: fileName, ofType: "txt")!)
}

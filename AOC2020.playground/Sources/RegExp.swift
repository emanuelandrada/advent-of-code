import Foundation

public extension NSRegularExpression {

    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }

    func captureGroups(string: String) -> [[String]] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let matchResults = matches(in: string, options: [], range: range)
        let nsString = string as NSString
        return matchResults.map { matchResult in
            (0..<matchResult.numberOfRanges).map{
                matchResult.range(at: $0)
            }.map {
                $0.location != NSNotFound ? nsString.substring(with: $0) as String : ""
            }
        }
    }
}

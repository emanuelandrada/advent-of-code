import Foundation

func map<T, R>(_ value: T, transform: (T) -> R) -> R {
  transform(value)
}

public func measuring<T>(_ block: () -> T) -> T {
    let startTime = Date()
    let retval = block()
    print("\(Date().timeIntervalSince(startTime) * 1000)ms")
    return retval
}

import Foundation

func map<T, R>(_ value: T, transform: (T) -> R) -> R {
  transform(value)
}

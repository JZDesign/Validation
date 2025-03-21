import Foundation

public protocol AutoLocalizing {
    var rawValue: String.LocalizationValue { get }
}

public extension AutoLocalizing {
    func callAsFunction() -> String {
        String(localized: rawValue, bundle: Module.bundle)
    }
}

private enum Module {
    static let bundle = Bundle.module
}


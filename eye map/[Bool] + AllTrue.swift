import Foundation

protocol BooleanType {
    var boolValue: Bool { get }
}

extension Bool: BooleanType {
    var boolValue: Bool {
        return self
    }
}

extension Array where Element: BooleanType {
    
    var allTrue: Bool {
        return reduce(true) { (sum, next) in return sum && next.boolValue }
    }
    
    var anyTrue: Bool {
        return contains { $0.boolValue == true }
    }
    
}

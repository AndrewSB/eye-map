import Foundation
import CoreMotion

enum Direction {
    case front
    case up
    case down
    case left
    case right
}

protocol Directionable {
    var direction: Direction { get }
}

extension CMRotationRate: Directionable {
    var direction: Direction {
        guard abs(x) > 1 && abs(y) > 1 else { return .front }
        
        switch x > y {
        case true:
            return x.isLess(than: 0) ? .left : .right
        case false:
            return y.isLess(than: 0) ? .down : .up
        }
    }
}

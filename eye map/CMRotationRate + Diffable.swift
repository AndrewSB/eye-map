import Foundation
import CoreMotion

protocol Diffable {
    func diff(with other: Self) -> Self
}

extension CMRotationRate: Diffable {
    
    static func - (lhs: CMRotationRate, rhs: CMRotationRate) -> CMRotationRate {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        let z = lhs.z - rhs.z
        
        return CMRotationRate(x: x, y: y, z: z)
    }
    
    static func + (lhs: CMRotationRate, rhs: CMRotationRate) -> CMRotationRate {
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        let z = lhs.z + rhs.z
        
        return CMRotationRate(x: x, y: y, z: z)
    }

    
    func diff(with other: CMRotationRate) -> CMRotationRate {
        let x = self.x - other.x
        let y = self.y - other.y
        let z = self.z - other.z
        
        return CMRotationRate(x: abs(x), y: abs(y), z: abs(z))
    }
    
}

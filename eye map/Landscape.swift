import Foundation
import CoreMotion

typealias Description = String

struct Landscape<T: Comparable & Diffable & Directionable, V> {
    var store: [(T, V)] = [(T, V)]()
    let margin: T
    
    init(margin: T) {
        self.margin = margin
    }
    
    mutating func append(new: (T, V)) -> Description {
        self.store.append(new)
        
        return "\(new.1) is at \(new.0.direction) \(new.0)"
    }

}

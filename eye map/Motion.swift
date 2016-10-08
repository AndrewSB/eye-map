//
//  Motion.swift
//  eye map
//
//  Created by Andrew Breckenridge on 10/8/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreMotion

class Motion {
    let manager = CMMotionManager()
    
    var onNext: ((CMRotationRate) -> ())?

    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    
    init() {
        self.bootstrapMotionManager()
    }
    
    func bootstrapMotionManager() {
        guard manager.isGyroAvailable else { assertionFailure(); return }
        
        manager.gyroUpdateInterval = 1 / 5
        manager.startGyroUpdates(to: OperationQueue.main) { data, error in
            self.onNext?(data!.rotationRate)
        }
    }
}

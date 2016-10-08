import UIKit

class Reducer {
    private let motion = Motion()
    private let vision: Vision
    
    
    
    init(previewView: UIView? = nil) {
        self.vision = Vision(previewView: previewView)
    }
    
    func start() {
        self.vision.startCapture()
    }
}

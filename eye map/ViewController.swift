import UIKit

class ViewController: UIViewController {
    let motion = Motion()
    var vision: Vision!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vision = Vision(previewView: self.view)

        motion.onNext = {
            print("m: \($0)")
        }
        
        vision.onNext = {
            print("v: \($0)")
        }
    
    }

    override func viewDidAppear(_ animated: Bool) {
        vision.startCapture()
    }


}


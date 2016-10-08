import UIKit
import CoreMotion
import RxSwift

class ViewController: UIViewController {
    var reducer: Reducer!
    var landscape = Landscape<CMRotationRate, String>(margin: CMRotationRate(x: 0.1, y: 0.1, z: 0.1))
    
    @IBOutlet weak var label: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reducer = Reducer(previewView: self.view)
        
        reducer.motionIsStill.map { !$0.1 }
            .asDriver(onErrorJustReturn: false)
            .drive(view.rx.hidden)
            .addDisposableTo(disposeBag)

        
        reducer.result!
            .subscribe(onNext: {
                let description = self.landscape.append(new: ($0.motionVector, $0.objectCandidate))
                
                self.label.text = $0.objectCandidate
                print(description)
            })
            .addDisposableTo(disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        reducer.start()
    }


}


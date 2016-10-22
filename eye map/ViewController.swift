import UIKit
import CoreMotion
import RxSwift

class ViewController: UIViewController {
    var reducer: Reducer!
    
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
                self.label.text = $0.objectCandidate
                print($0.objectCandidate)
            })
            .addDisposableTo(disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        reducer.start()
    }


}


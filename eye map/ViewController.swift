import UIKit
import RxSwift

class ViewController: UIViewController {
    let reducer = Reducer()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reducer.result.subscribe(onNext: { print("\($0)") })
            .addDisposableTo(disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        reducer.start()
    }


}


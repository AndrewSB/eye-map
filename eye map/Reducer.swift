import UIKit
import RxSwift
import CoreMotion

typealias VisionResult = (String, Float)

class Reducer {
    private let motion = Motion()
    private let vision: Vision
    
    private let motionSubject = PublishSubject<CMRotationRate>()
    private let visionSubject = PublishSubject<([VisionResult])>()
    var result: Observable<Result>!
    
    init(previewView: UIView? = nil) {
        self.vision = Vision(previewView: previewView)
        
        self.motion.onNext = motionSubject.onNext
        self.vision.onNext = visionSubject.onNext
        
        let _ = Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
        
        self.result = motionSubject
            .scan(nil) { oldValue, newMotionVector in
                guard let oldValue = oldValue else { return newMotionVector }
                
                return oldValue ~= newMotionVector ? newMotionVector : nil
            }
            .filter { $0 != nil }
            .map { $0! }
            // at this point, we want to scan the image, and parcel it forward
            .flatMap(embedVisionValue)
            // only fire once per new candidate
            .distinctUntilChanged { $0.objectCandidate == $1.objectCandidate }
    
    }
    
    func start() {
        self.vision.startCapture()
    }
    
    fileprivate func embedVisionValue(motionVector: CMRotationRate) -> Observable<Result> {
        return self.visionSubject.asObservable()
            .map { visionCandidates in
                return visionCandidates
                    .filter { $0.1 > 0.6 }
                    .sorted { $1.1 > $0.1 }
                    .first
            }
            .filter { $0 != nil }
            .map { $0! }
            .scan([VisionResult](), accumulator: Reducer.validateNewVisionResult)
            .filter { $0.count == 3 }
            .map { Result(motionVector: motionVector, objectCandidate: $0.last!.0) }
    }
    
    fileprivate static func validateNewVisionResult(acc: [VisionResult], newValue: VisionResult) -> [VisionResult] {
        let newValueMatchesState = acc.reduce(true) { flag, currAcc in
            return flag && currAcc.0 == newValue.0
        }
        
        switch newValueMatchesState {
        case true:
            return acc + [newValue]
        case false:
            return []
        }
    }
}

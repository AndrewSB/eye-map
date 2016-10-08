import UIKit
import RxSwift
import RxCocoa
import CoreMotion

typealias VisionResult = (String, Float)

class Reducer {
    private let motion = Motion()
    private let vision: Vision
    
    private let motionSubject = PublishSubject<CMRotationRate>()
    private let visionSubject = PublishSubject<([VisionResult])>()
    
    var motionIsStill: Observable<(CMRotationRate?, Bool)>!
    var result: Observable<Result>?
    var motionSum: CMRotationRate?
    
    init(previewView: UIView? = nil) {
        self.vision = Vision(previewView: previewView)
        
        self.motion.onNext = motionSubject.onNext
        self.vision.onNext = visionSubject.onNext
        
        self.motionIsStill = motionSubject
            .map { motionValue -> CMRotationRate in
                guard self.motionSum != nil else {
                    self.motionSum = motionValue
                    return self.motionSum!
                }
                self.motionSum = self.motionSum! + motionValue
                
                return self.motionSum!
            }
            .scan((nil, false)) { old, new -> (CMRotationRate?, Bool) in
                guard old.0 != nil else { return (new, false) }
                
                if old.0! ~= new {
                    return (new, true)
                } else {
                    return (new, false)
                }
        }
        
        self.result = self.motionIsStill
            .filter { $0.1 == true }
            .distinctUntilChanged { $0.1 == $1.1 }
            .map { $0.0! }
            // at this point, we want to scan the image, and move it to the point in the pipeline
            .flatMapLatest(embedVisionValue)
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

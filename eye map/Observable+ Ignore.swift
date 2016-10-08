import RxSwift

extension Observable where Element: Equatable {
    func ignore(_ value: Element) -> Observable<Element> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
}

import Foundation

protocol StateSavable {
    var identifier: String { get }
    func getStateParams() -> [String: Any]?
}

protocol StateRestorable {
    func restoreState(with params: [String: Any]?)
}

typealias StateManageable = StateSavable & StateRestorable // 두 프로토콜을 모두 채택하는 경우

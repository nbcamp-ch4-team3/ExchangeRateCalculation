import Foundation

enum CoreDataError: LocalizedError {
    case addFavoriteFailed(error: Error?)
    case deleteFavoriteFailed(error: Error?)
    case fetchFavoritesFailed(error: Error?)

    var errorDescription: String? {
        switch self {
        case .addFavoriteFailed:
            return "즐겨찾기 추가에 실패했습니다."
        case .deleteFavoriteFailed:
            return "즐겨찾기 삭제에 실패했습니다."
        case .fetchFavoritesFailed:
            return "즐겨찾기 목록을 불러오는 데에 실패했습니다."
        }
    }

    var debugDescription: String {
        switch self {
        case .addFavoriteFailed(let error):
            return "CoreData 즐겨찾기 추가 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
        case .deleteFavoriteFailed(let error):
            return "CoreData 즐겨찾기 삭제 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
        case .fetchFavoritesFailed(let error):
            return "CoreData 즐겨찾기 목록 가져오기 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
        }
    }
}

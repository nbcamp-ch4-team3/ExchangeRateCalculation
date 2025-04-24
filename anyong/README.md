# ExchangeRateCalculation
### 실시간 환율 정보를 Open API로 받아오고, 금액을 변환하는 앱
<img src="https://github.com/user-attachments/assets/99f126a4-2097-4dda-bee3-f10a9ffb47b3" width="100%" height="500" alt="Thumbnail" />

### 구현 기능
- ✏️ Level 1 - 메인 UI 기초 작업 + 네트워크 통신
- ✏️ Level 2 - 메인 화면 구성
- ✏️ Level 3 - 필터링 기능 구현
- ✏️ Level 4 - 환율 계산기 화면 이동
- ✏️ Level 5 - 환율 계산
- ✏️ Level 6 - MVVM 패턴 도입하여 뷰와 로직 분리
- ✏️ Level 7 - 즐겨찾기 기능 상단 고정
- ✏️ Level 8 - 기존 데이터와 비교해 상승 하락 표시
- ✏️ Level 9 - 다크모드 대응
- ✏️ Level 10 - 앱 상태 저장 및 복원

# 시연영상
| Light | Dark |   
|:-:|:-:|
| <img src="https://github.com/user-attachments/assets/c62a1193-8797-4c76-950d-a4001b626627" width="250"/> | <img src="https://github.com/user-attachments/assets/c0e65def-a645-4996-847c-5a18a6a22354" width="250"/> |

# 트레블 슈팅
- 비동기 함수 내에서 CoreData를 사용하는 경우 일정 확률로 런타임 에러 발생
- 원인으로 생각되는 것은 CoreData는 Main Thread에서 동작해야 하는데 비동기 함수 내에서 사용하여 발생한 것 같습니다.
- 따라서 backgroundContext를 선언하고 비동기 작업에서 호출 시 해당 context를 사용하도록 했습니다.
- 현재는 fetchAllData 함수에만 적용되어 업데이트 관련 메서드에서 간혹 런타임 에러 발생합니다.(수정 예정)
```swift
// CoreDataStorage
var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

// 사용(CurrencyCodeStorageService)
func fetchAllData() throws -> [CoreDataCurrency] {
        do {
            let context = self.coreDataStorage.backgroundContext
            var result: [CoreDataCurrency] = []
            
            try context.performAndWait {
                let codes = try context.fetch(CurrencyCode.fetchRequest()) as? [CurrencyCode] ?? []
                
                result = codes.compactMap {
                    CoreDataCurrency(
                        code: $0.code ?? "",
                        exchangeRate: $0.exchangeRate,
                        isBookmark: $0.isBookmark
                    )
                }
            }
            
            return result
        } catch {
            throw CoreDataError.fetchFailed
        }
    }
```

# 메모리 누수 디버깅
### 아래는 현재 코드로 디버깅을 한 결과로 메모리 누수가 발생하지 않았습니다.
- Scheme 설정

<img src="https://github.com/user-attachments/assets/7a9aa5c8-c3d8-43d0-86c8-facb4784afe9" width="60%" height="300" alt="Thumbnail" /><br>
- 디버깅 결과

<img src="https://github.com/user-attachments/assets/a74bb5e0-4f50-427f-b336-40274fde0d24" width="100%" height="800" alt="Thumbnail" /><br>

- 고의로 메모리 누수를 발생시키기 위한 코드
- weak self를 주석처리하여 강한 참조가 이루어지도록 수정
```swift
        self.action = { /*[weak self]*/ action in
//            guard let self else { return }
            
            switch action {
            case let .convert(input):
                self.convertHandle(input)
            case .initialize:
                self.initialHandle()
            }
        }
```
<br>
- 디버깅 결과(메모리 누수 발생)
<img src="https://github.com/user-attachments/assets/338b4b56-0eec-49c6-ba01-d3ce93466b2d" width="100%" height="800" alt="Thumbnail" />

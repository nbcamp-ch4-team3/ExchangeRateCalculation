# ExchangeRateCalculation
### 실시간 환율 정보를 Open API로 받아오고, 금액을 변환하거나, 관심 있는 통화를 즐겨찾기에 추가해 상단 고정 가능한 앱입니다. 
<img src = "https://teamsparta.notion.site/image/attachment%3A196a0c68-175b-4be9-9ed9-62c759edafd7%3A%E1%84%80%E1%85%AA%E1%84%8C%E1%85%A6_%E1%84%8A%E1%85%A5%E1%86%B7%E1%84%82%E1%85%A6%E1%84%8B%E1%85%B5%E1%86%AF_%E1%84%86%E1%85%A1%E1%84%89%E1%85%B3%E1%84%90%E1%85%A5_%E1%84%8B%E1%85%A2%E1%86%B8_%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF_%E1%84%89%E1%85%AE%E1%86%A8%E1%84%85%E1%85%A7%E1%86%AB.png?table=block&id=1d42dc3e-f514-80c8-a49a-cb430840c75e&spaceId=83c75a39-3aba-4ba4-a792-7aefe4b07895&width=1420&userId=&cache=v2">

## 요구사항
<details>
<summary>Level 1 - 메인 UI 기초 작업 + 데이터 불러오기</summary>
<div markdown="1">

### Level 1
<aside>
🧑🏻‍💻 Level 1 - 메인 UI 기초 작업 + 데이터 불러오기

- `UILabel`, `UITableView`, 을 이용해서 기본적인 UI 를 구성합니다.
- Cell 의 높이는 자유롭게 지정합니다.
- 외부 Open API를 통해 실시간 환율 데이터를 불러오고 UI(테이블 뷰)에 반영해보세요.
- 사용 API: GET https://open.er-api.com/v6/latest/USD
    - url의 마지막 경로가 기준이 되는 통화. /USD 로 조회시 1달러 기준으로 다른 통화 환율이 표시됨.
    KRW로 바꾸어서 요청을 보내면 1원 기준으로 다른 통화 환율이 표시됨
- 응답 데이터를 `Codable`을 사용해 파싱하고, `ViewModel` 또는 `DataService`에서 관리합니다.
- 파싱한 데이터를 테이블 뷰에 표시합니다.
    - 소수점 4자리까지만 표시합니다
- 데이터가 없는 경우 "데이터를 불러올 수 없습니다" `Alert` 표시
</aside>

</div>
</details>

<details>
<summary>Level 2 - 메인 화면 구성</summary>
<div markdown="1">

### Level2

<aside>
🧑🏻‍💻 Level2 - 메인 화면 구성

- 메인 화면을 구성하고 환율 데이터를 표시할 기본 UI를 구성해보세요.
- `UISearchBar`와 `UITableView`를 SnapKit을 활용해 구성합니다.
- 셀에는 다음 정보를 포함합니다:
    - 통화 코드 (예: KRW)
    - 국가명 (예: 대한민국)
    - 환율 값 (예: 1466.12)
    <details>
    <summary>통화 코드 / 국가 명 매핑</summary>
    <div markdown="1">
        [
        "USD": "미국",
        "AED": "아랍에미리트",
        "AFN": "아프가니스탄",
        "ALL": "알바니아",
        "AMD": "아르메니아",
        "ANG": "네덜란드령 안틸레스",
        "AOA": "앙골라",
        "ARS": "아르헨티나",
        "AUD": "오스트레일리아",
        "AWG": "아루바",
        "AZN": "아제르바이잔",
        "BAM": "보스니아 헤르체고비나",
        "BBD": "바베이도스",
        "BDT": "방글라데시",
        "BGN": "불가리아",
        "BHD": "바레인",
        "BIF": "부룬디",
        "BMD": "버뮤다",
        "BND": "브루나이",
        "BOB": "볼리비아",
        "BRL": "브라질",
        "BSD": "바하마",
        "BTN": "부탄",
        "BWP": "보츠와나",
        "BYN": "벨라루스",
        "BZD": "벨리즈",
        "CAD": "캐나다",
        "CDF": "콩고민주공화국",
        "CHF": "스위스",
        "CLP": "칠레",
        "CNY": "중국",
        "COP": "콜롬비아",
        "CRC": "코스타리카",
        "CUP": "쿠바",
        "CVE": "카보베르데",
        "CZK": "체코",
        "DJF": "지부티",
        "DKK": "덴마크",
        "DOP": "도미니카공화국",
        "DZD": "알제리",
        "EGP": "이집트",
        "ERN": "에리트레아",
        "ETB": "에티오피아",
        "EUR": "유럽연합",
        "FJD": "피지",
        "FKP": "포클랜드제도",
        "FOK": "페로제도",
        "GBP": "영국",
        "GEL": "조지아",
        "GGP": "건지",
        "GHS": "가나",
        "GIP": "지브롤터",
        "GMD": "감비아",
        "GNF": "기니",
        "GTQ": "과테말라",
        "GYD": "가이아나",
        "HKD": "홍콩",
        "HNL": "온두라스",
        "HRK": "크로아티아",
        "HTG": "아이티",
        "HUF": "헝가리",
        "IDR": "인도네시아",
        "ILS": "이스라엘",
        "IMP": "맨섬",
        "INR": "인도",
        "IQD": "이라크",
        "IRR": "이란",
        "ISK": "아이슬란드",
        "JEP": "저지섬",
        "JMD": "자메이카",
        "JOD": "요르단",
        "JPY": "일본",
        "KES": "케냐",
        "KGS": "키르기스스탄",
        "KHR": "캄보디아",
        "KID": "키리바시",
        "KMF": "코모로",
        "KRW": "대한민국",
        "KWD": "쿠웨이트",
        "KYD": "케이맨 제도",
        "KZT": "카자흐스탄",
        "LAK": "라오스",
        "LBP": "레바논",
        "LKR": "스리랑카",
        "LRD": "라이베리아",
        "LSL": "레소토",
        "LYD": "리비아",
        "MAD": "모로코",
        "MDL": "몰도바",
        "MGA": "마다가스카르",
        "MKD": "북마케도니아",
        "MMK": "미얀마",
        "MNT": "몽골",
        "MOP": "마카오",
        "MRU": "모리타니",
        "MUR": "모리셔스",
        "MVR": "몰디브",
        "MWK": "말라위",
        "MXN": "멕시코",
        "MYR": "말레이시아",
        "MZN": "모잠비크",
        "NAD": "나미비아",
        "NGN": "나이지리아",
        "NIO": "니카라과",
        "NOK": "노르웨이",
        "NPR": "네팔",
        "NZD": "뉴질랜드",
        "OMR": "오만",
        "PAB": "파나마",
        "PEN": "페루",
        "PGK": "파푸아뉴기니",
        "PHP": "필리핀",
        "PKR": "파키스탄",
        "PLN": "폴란드",
        "PYG": "파라과이",
        "QAR": "카타르",
        "RON": "루마니아",
        "RSD": "세르비아",
        "RUB": "러시아",
        "RWF": "르완다",
        "SAR": "사우디아라비아",
        "SBD": "솔로몬 제도",
        "SCR": "세이셸",
        "SDG": "수단",
        "SEK": "스웨덴",
        "SGD": "싱가포르",
        "SHP": "세인트헬레나",
        "SLE": "시에라리온",
        "SLL": "시에라리온",
        "SOS": "소말리아",
        "SRD": "수리남",
        "SSP": "남수단",
        "STN": "상투메 프린시페",
        "SYP": "시리아",
        "SZL": "에스와티니",
        "THB": "태국",
        "TJS": "타지키스탄",
        "TMT": "투르크메니스탄",
        "TND": "튀니지",
        "TOP": "통가",
        "TRY": "튀르키예",
        "TTD": "트리니다드 토바고",
        "TVD": "투발루",
        "TWD": "대만",
        "TZS": "탄자니아",
        "UAH": "우크라이나",
        "UGX": "우간다",
        "UYU": "우루과이",
        "UZS": "우즈베키스탄",
        "VES": "베네수엘라",
        "VND": "베트남",
        "VUV": "바누아투",
        "WST": "사모아",
        "XAF": "중앙아프리카 CFA 프랑",
        "XCD": "동카리브 제도",
        "XCG": "가상통화 (Crypto Generic)",
        "XDR": "IMF 특별인출권",
        "XOF": "서아프리카 CFA 프랑",
        "XPF": "프랑스령 폴리네시아",
        "YER": "예멘",
        "ZAR": "남아프리카 공화국",
        "ZMW": "잠비아",
        "ZWL": "짐바브웨"
        ]
    </div>
    </details>
    <details>
    <summary>AutoLayout 및 컴포넌트 제약 조건</summary>
    <div markdown="1">
    `ExchangeRateView AutoLayout` 및 컴포넌트 제약 조건
    
    - UISearchBar
        - top = safeAreaLayoutGuide
        - leading, trailing = superView
    - UITableView
        - top = searchBar.bottom
        - leading, trailing, bottom = safeAreaLayoutGuide
    
    `ExchangeRateCell AutoLayout`및 컴포넌트 제약 조건
    
    - contentView
        - edges = superView (top, leading, trailing, bottom)
        - height = 60
    - labelStackView (currencyLabel + countryLabel)
        - leading = superView + 16
        - centerY = superView
    - rateLabel
        - trailing = superView - 16
        - centerY = superView
        - leading ≥ labelStackView.trailing + 16
        - width = 120
    - labelStackView 내부 설정
        - axis = vertical
        - spacing = 4
    - currencyLabel 설정
        - font = .systemFont(size: 16, weight: .medium)
    - countryLabel 설정
        - font = .systemFont(size: 14)
    - textColor = .gray
        - rateLabel 설정
        - font = .systemFont(size: 16)
        - textAlignment = .right
    </div>      
    </details>
    <details>
    <summary>다양한 기기 대응</summary>
    <div markdown="1">  
        - iOS 16.0과 호환 가능한 iPhone 모델(SE 2세대, 16 Pro Max 등)의 다양한 디바이스 지원과 Portrait 모드/ Landscape 모드를 대응하여 왼쪽과 같이 구현해보세요.
            - iOS 16.0 호환 모델 확인: [https://support.apple.com/ko-kr/guide/iphone/iphe3fa5df43/16.0/ios/16.0](https://support.apple.com/ko-kr/guide/iphone/iphe3fa5df43/18.0/ios/18.0)
            - iOS 16 이상 모든 버전을 지원할 수 있도록 구현
            - Portrait 모드와 Landscape 모드 대응
            - **콘텐츠가 노치나 다이나믹 아일랜드 영역에 가려지지 않도록 구현해보세요.**
            - Autolayout이 제대로 구현되어있지 않다면 콘솔창에 Autolayout 관련 경고 메시지가 출력됩니다. 디바이스 방향을 바꾸더라도 (Portrait 모드 ↔ Landscape 모드) 콘솔창에 Autolayout 관련 경고 메시지가 뜨지 않도록 구현해보세요.
    </div>
    </details>
    - 오토레이아웃을 포함한 UI 디버깅 상황 중 Xcode 툴을 사용하여 문제 정의 
        + 문제 해결한 사례에 대해 그 해결 과정에 대해 기록합니다(1개 이상 필수)

    - UI 디버깅에 관여하는 Xcode 내 툴
        - View Debugger (Debug View Hierarchy)
        - Debug Area 콘솔 로그
        - Size Inspector
</aside>

</div>
</details>

<details>
<summary>Level 3 - 필터링 기능 구현</summary>
<div markdown="1">

### Level 3

<aside>
🧑🏻‍💻 Level 3 - 필터링 기능 구현

- 통화 코드 또는 국가명을 검색할 수 있는 필터링 기능을 구현해보세요.
- 검색결과가 없을 경우 "검색 결과 없음" 표시
- 검색어가 비어있으면 전체 리스트 노출
</aside>
</div>
</details>

<details>
<summary>Level 4 - 환율 계산기로 이동</summary>
<div markdown="1">

### Level 4
<aside>
🧑🏻‍💻 Level 4 - 환율 계산기로 이동

- 테이블 셀을 클릭했을 때, 환율 계산기로 이동하는 기능을 구현합니다.
- `UINavigationController.pushViewController()`를 사용하여 화면 전환
- 계산기 화면 구성 요소:
    - 통화 코드 및 국가 이름 레이블
    - 입력 필드 (`UITextField`)
    - 변환 버튼 (`UIButton`)
    - 결과 표시 (`UILabel`)
</aside>
</div>
</details>

<details>
<summary>Level 5 - 입력한 금액 실시간 반영</summary>
<div markdown="1">

### Level 5
<aside>
🧑🏻‍💻 Level 5 - 입력한 금액 실시간 반영

- 환율 계산기 화면에서 입력한 금액을 실시간으로 환산하는 기능을 구현해보세요.
    - 방법 1
        - https://open.er-api.com/v6/latest/USD api를 동일하게 사용해서 특정 currency의 환율을 가져와서 계산
    - 방법 2
        - 환율 정보 화면에서 이미 api를 호출했으므로, 셀에 있는 환율 정보를 가지고 계산기 화면에서 활용
- 잘못된 입력값(빈칸, 숫자 아님 등)은 `Alert` 처리
    - 빈칸일 경우 : 금액을 입력해주세요
    - 숫자 아닐 경우 : 올바른 숫자를 입력해주세요
- 결과값은 소수점 둘째자리로 반올림하여 표시
</aside>
</div>
</details>

<details>
<summary>Level 6 - MVVM 패턴을 도입하여 View와 로직을 분리</summary>
<div markdown="1">

### Level 6
🧑🏻‍💻 Level 6 - MVVM 패턴을 도입하여 View와 로직을 분리
ViewModel에서 API 호출, 필터링, 환율 계산 등의 로직 처리
ViewController는 ViewModel의 데이터를 바인딩하고 UI만 담당
ViewModel은 아래의 ViewModelProtocol을 채택하여 구현
ViewController에서 ViewModel의 State를 클로저로 바인딩
예시 구조:
```
protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get }
    var state: State { get }
}

class CalculatorViewModel: ViewModelProtocol { }

class ExchangeRateViewModel: ViewModelProtocol { }
```
</div>
</details>

<details>
<summary>Level 7 - 즐겨찾기 기능 상단 고정</summary>
<div markdown="1">

### Level 7
<aside>
🧑🏻‍💻 Level 7 - 즐겨찾기 기능 상단 고정

- 즐겨찾기(⭐️) 기능을 추가해, 즐겨찾은 통화를 리스트 상단에 고정해보세요.
- 셀 우측에 ⭐ / ☆ 버튼 추가
    - 이미지 이름 : star.fill / star
- 클릭 시 해당 통화 코드가 `CoreData`에 저장/삭제됨
- 리스트 출력 시 즐겨찾기 데이터를 먼저 상단에 배치
    - 즐겨찾기된 데이터도 알파벳 오름차순 정렬이 되어야 함
- 즐겨찾기 상태에 따라 ⭐ / ☆ UI를 다르게 표시
</aside>
</div>
</details>

<details>
<summary>Level 8 - 상승 🔼 하락🔽  여부 표시</summary>
<div markdown="1">

### Level 8
<aside>
🧑🏻‍💻 Level 8 - 상승 🔼 하락🔽  여부 표시

- 환율 데이터를 캐싱하고, 이전 데이터와 비교해 상승 🔼 / 하락 🔽 여부를 표시해보세요.
- 앱 실행 시 이전 데이터를 `CoreData`에서 로드
- 새 데이터를 받아오면 이전 값과 비교 후 방향 아이콘 표시
- 아이콘 표시 기준:
    - `abs(new - old) > 0.01` 일때 상승/하락 아이콘 표시
    - `abs(new - old) <= 0.01` 일때는 아이콘 표시하지 않기(아이콘의 너비만큼 여백으로 처리하여 환율 숫자의 우측이 정렬되도록 함)
- Hint. 환율 API는 하루마다 갱신됩니다. 상승과 하락 여부를 알려면 어떻게 하면 좋을까요?
    - API 응답값의 시간과 관련된 값들을 활용
    - 테스트 용이성을 위해서 목 데이터(Mock data)를 생성 후 활용
</aside>
</div>
</details>


<details>
<summary>Level 9 - 다크모드 구현</summary>
<div markdown="1">

### Level 9
<aside>
🧑🏻‍💻 Level 9 - 다크모드 구현

- 다크모드 UI를 구현해보세요.
- 시스템 색상`label`, `systemBackground`, `secondaryLabel`등을 사용하여 자동으로 다크모드에 대응합니다.
- 또는 Asset Catalog에서 Any/Dark 색상 설정을 활용할 수 있습니다.
</aside>
</div>
</details>


<details>
<summary>Level 10 - 앱 상태 저장 및 복원</summary>
<div markdown="1">

### Level 10
<aside>
🧑🏻‍💻 Level 10 - 앱 상태 저장 및 복원

- 사용자가 마지막으로 본 화면 정보를 CoreData에 저장합니다.
- 앱을 재시작하면 환율 리스트 화면, 환율 계산기 화면 중 마지막으로 본 화면으로 이동합니다
    - 환율 계산기 화면은 어떤 통화에 대한 계산기 화면인지까지만 이동하고 입력 숫자, 결과값은 저장하지 않습니다
    - 환율 계산기 화면에서의 환율은 coreData에 저장된 환율을 가져옵니다
- `AppDelegate` 혹은 `SceneDelegate` 를 이용합니다
</aside>
</div>
</details>


<details>
<summary>Level 11 -  메모리 이슈 디버깅 및 개선 경험 문서화</summary>
<div markdown="1">

### Level 11
<aside>
🧑🏻‍💻 Level 11 -  메모리 이슈 디버깅 및 개선 경험 문서화

- 메모리 누수 혹은 클로저 강한 참조로 인한 Retain Cycle 발생 여부 확인 및 해소
    - ViewModel의 State를 ViewController에 바인딩할때 클로저를 사용하게 될텐데 강한 참조로 인해 메모리 누수가 발생할 수 있습니다.
- 분석 결과를 README에 서술하여, 내가 해결한 디버깅 경험을 어필해 보세요.
    - Hint. Xcode 내 툴을 사용하여 문제를 정의하고, 해결해 봅니다.
        - Memory Graph Debugger
        - Instrument(Leaks, Allocations, Time Profiler)
        - Zombie Objects
- 유의) Lv 11 과제 완료 기준
    - 메모리 누수가 발견된 경우
        - 문제 발견 - 문제 분석 - 문제 해결(Xcode 툴 사용) 프로세스를 거치고, 해결 전후에 대한 결과값 차이를 README에 반영
    - 메모리 누수가 발견되지 않은 경우
        - Xcode 툴을 사용하여 메모리 누수가 없었음을 입증하고 그 과정을 README에 반영
</aside>
</div>
</details>


<details>
<summary>Level 12 -  Clean Architecture 적용</summary>
<div markdown="1">

### Level 12
<aside>
🧑🏻‍💻 Level 12 -  Clean Architecture 적용

- 프로젝트 구조를 다음과 같이 구성해보세요:

```
Domain
├── Model
├── UseCase

Data
├── Entity
├── Repository

Presentation
├── ViewModel
├── View
├── ViewControl
```

- View → ViewModel → UseCase → Repository → API or UserDefault 순으로 호출 흐름을 구성해 관심사를 분리합니다.
- 참고자료
    - https://github.com/kudoleh/iOS-Clean-Architecture-MVVM
    - https://medium.com/@hyosing92/ios-cleanarchitecture-mvvm-e1b390b18e83
    - https://jaeseo0519.tistory.com/408
</aside>
</div>
</details>

## UI 디버깅
<details>
<summary>UI 디버깅</summary>
<div markdown="1">
<table>
  <tr>
    <td colspan="2" style="text-align: leading; font-weight: bold;">
    UI 디버깅에서 테이블뷰의 bottom이 superview에 닿지 않고 safeAreaGuideLine에 닿아있는 것을 발견
    </td>
  </tr>
    <tr>
    <td style="text-align: center;"><img src="https://github.com/user-attachments/assets/ef8798e4-bb25-49d8-88c2-f1cc85d13f36" width="400"/></td>
    <td style="text-align: center;"><img src="https://github.com/user-attachments/assets/09f7e66b-9900-4fe0-aad6-347e3ca1471f" width="300"/></td>
  </tr>

  <tr>
    <td colspan="2" style="text-align: leading; font-weight: bold;">
    수정 후
    </td>
  </tr>
    <tr>
    <td style="text-align: center;"><img src="https://github.com/user-attachments/assets/9dd8772b-920d-493c-9869-c425a9ef9d33" width="400"/></td>
    <td style="text-align: center;"><img src="https://github.com/user-attachments/assets/9ca40f69-ad80-48e4-8105-c6fb15a4af91" width="300"/></td>
  </tr>
</table>

</div>
</details>


## 메모리 누수 디버깅
### 현재 코드에서는 메모리 누수가 발견되지 않았다
### Debug Memory Graph
https://github.com/user-attachments/assets/3231e9dd-27d9-4b01-afe2-73a52a62bfe5

### Instruments - Leaks
https://github.com/user-attachments/assets/918bf740-0f89-4b29-b848-5ebefa101965


### 메모리 누수 실험을 위해 클로저에서 강한 참조를 만듦
![Image](https://github.com/user-attachments/assets/7f93cc20-d670-4555-87fe-d095a14cac81)

## 시연영상
![Simulator Screen Recording - iPhone 16 Pro - 2025-03-31 at 21 51 35](https://github.com/user-attachments/assets/3d8f5f6e-21c9-451f-a1cd-917acf72769e)


## PR 
- [Level 1, 2](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/1)
- [Level 3, 4, 5](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/6)
- [Level 6](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/9)
- [Level 7](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/13)
- [Level 8](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/17)
- [Level 9, 10](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/21)


## 트러블 슈팅
- [Error vs LocalizedError: Swift 에러 처리, 어떤 걸 선택할까?](https://soo-hyn.tistory.com/147)
- [싱글톤 초기화 시점에 따른 Main Thread 오류 해결](https://soo-hyn.tistory.com/148)

# ExchangeRateCalculation

### 실시간 환율 정보를 받아오고, 금액을 변환할 수 있는 앱입니다. 관심 있는 통화를 즐겨찾기에 추가해 상단 고정해 편리하게 볼 수 있습니다!
![image](https://github.com/user-attachments/assets/fab06842-ad66-46b5-9ac6-fc2875b8186b)

## 요구사항
<details><summary>레벨 1</summary>

🧑🏻‍💻 **Level 1 - 메인 UI 기초 작업 + 데이터 불러오기**

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

</details>  
<details><summary>레벨 2</summary>

🧑🏻‍💻 **Level2 - 메인 화면 구성**

- 메인 화면을 구성하고 환율 데이터를 표시할 기본 UI를 구성해보세요.
- `UISearchBar`와 `UITableView`를 SnapKit을 활용해 구성합니다.
- 셀에는 다음 정보를 포함합니다:
    - 통화 코드 (예: KRW)
    - 국가명 (예: 대한민국)
    - 환율 값 (예: 1466.12)
    - 통화 코드 / 국가 명 매핑
- **AutoLayout 및 컴포넌트 제약 조건**
- 다양한 기기 대응
- 오토레이아웃을 포함한 UI 디버깅 상황 중 Xcode 툴을 사용하여 문제 정의 + 문제 해결한 사례에 대해 그 해결 과정에 대해 기록합니다(1개 이상 필수)

</details>  
<details><summary>레벨 3</summary>
<aside>
🧑🏻‍💻 **Level 3 - 필터링 기능 구현**

- 통화 코드 또는 국가명을 검색할 수 있는 필터링 기능을 구현해보세요.
- 검색결과가 없을 경우 "검색 결과 없음" 표시
- 검색어가 비어있으면 전체 리스트 노출

</details>  
<details><summary>레벨 4</summary>

🧑🏻‍💻 **Level 4 - 환율 계산기로 이동**

- 테이블 셀을 클릭했을 때, 환율 계산기로 이동하는 기능을 구현합니다.
- `UINavigationController.pushViewController()`를 사용하여 화면 전환
- 계산기 화면 구성 요소:
    - 통화 코드 및 국가 이름 레이블
    - 입력 필드 (`UITextField`)
    - 변환 버튼 (`UIButton`)
    - 결과 표시 (`UILabel`)
- **AutoLayout 및 컴포넌트 제약조건**
</aside>
</details>  
<details><summary>레벨 5</summary>
<aside>
🧑🏻‍💻 **Level 5 - 입력한 금액 실시간 반영**

- 환율 계산기 화면에서 입력한 금액을 실시간으로 환산하는 기능을 구현해보세요.
- 버튼 클릭 시 API를 호출하여 결과 표시
- 잘못된 입력값(빈칸, 숫자 아님 등)은 `Alert` 처리
    - 빈칸일 경우 : 금액을 입력해주세요
    - 숫자 아닐 경우 : 올바른 숫자를 입력해주세요
- 결과값은 소수점 둘째자리로 반올림하여 표시

</details>  
<details><summary>레벨 6</summary>
Level 6 - MVVM 패턴을 도입하여 View와 로직을 분리

- ViewModel에서 API 호출, 필터링, 환율 계산 등의 로직 처리
- ViewController는 ViewModel의 데이터를 바인딩하고 UI만 담당
- ViewModel은 아래의 ViewModelProtocol을 채택하여 구현
</details>  
<details><summary>레벨 7</summary>

🧑🏻‍💻 **Level 7 - 즐겨찾기 기능 상단 고정**

- 즐겨찾기(⭐️) 기능을 추가해, 즐겨찾은 통화를 리스트 상단에 고정해보세요.
- 셀 우측에 ⭐ / ☆ 버튼 추가
    - 이미지 이름 : star.fill / star
- 클릭 시 해당 통화 코드가 `CoreData`에 저장/삭제됨
- 리스트 출력 시 즐겨찾기 데이터를 먼저 상단에 배치
    - 즐겨찾기된 데이터도 알파벳 오름차순 정렬이 되어야 함
- 즐겨찾기 상태에 따라 ⭐ / ☆ UI를 다르게 표시

</details>  
<details><summary>레벨 8</summary>

🧑🏻‍💻 **Level 8 - 상승** 🔼 **하락** 🔽  **여부 표시**

- 환율 데이터를 캐싱하고, 이전 데이터와 비교해 상승 🔼 / 하락 🔽 여부를 표시해보세요.
- 앱 실행 시 이전 데이터를 `CoreData`에서 로드
- 새 데이터를 받아오면 이전 값과 비교 후 방향 아이콘 표시
- 아이콘 표시 기준:
    - `abs(new - old) > 0.01` 일때 상승/하락 아이콘 표시
    - `abs(new - old) <= 0.01` 일때는 아이콘 표시하지 않기(아이콘의 너비만큼 여백으로 처리하여 환율 숫자의 우측이 정렬되도록 함)
- **Hint. 환율 API는 하루마다 갱신됩니다. 상승과 하락 여부를 알려면 어떻게 하면 좋을까요?**
    - API 응답값의 시간과 관련된 값들을 활용
    - 테스트 용이성을 위해서 목 데이터(Mock data)를 생성 후 활용

</details>  
<details><summary>레벨 9</summary>

🧑🏻‍💻 **Level 9 - 다크모드 구현**

- 다크모드 UI를 구현해보세요.
- 시스템 색상`label`, `systemBackground`, `secondaryLabel`등을 사용하여 자동으로 다크모드에 대응합니다.
- 또는 Asset Catalog에서 Any/Dark 색상 설정을 활용할 수 있습니다.

</details>  
<details><summary>레벨 10</summary>

🧑🏻‍💻 **Level 10 -** 앱 상태 저장 및 복원

- 사용자가 마지막으로 본 화면 정보를 CoreData에 저장합니다.
- 앱을 재시작하면 환율 리스트 화면, 환율 계산기 화면 중 마지막으로 본 화면으로 이동합니다
- `AppDelegate` 혹은 `SceneDelegate` 를 이용합니다

</details>  
<details><summary>레벨 11</summary>

🧑🏻‍💻 **Level 11 -  메모리 이슈 디버깅 및 개선 경험 문서화**

- 메모리 누수 혹은 ViewModel 강한 참조로 인한 Retain Cycle 발생 여부 확인 및 해소
- 분석 결과를 README에 서술하여, 내가 해결한 디버깅 경험을 어필해 보세요.
    - Hint. Xcode 내 툴을 사용하여 문제를 정의하고, 해결해 봅니다.
        - Memory Graph Debugger
        - Instrument(Leaks, Allocations, Time Profiler)
        - Zombie Objects
- **유의) 문제 발견 - 문제 분석 - 문제 해결(Xcode 툴 사용) 프로세스를 거치고, 해결 전후에 대한 결과값 차이를 README에 반영해야 Lv 11이 마무리 됩니다.**

</details>  
<details><summary>레벨 12</summary>

🧑🏻‍💻 **Level 12 -  Clean Architecture 적용**

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

</details>  

## 시연영상

![전 기능 시뮬레이트 영상](https://github.com/user-attachments/assets/9e72290e-2dcf-42fd-b004-fdec86a5cd26)
![다크 모드 및 통화 계산](https://github.com/user-attachments/assets/0a6d5073-2ad0-4fcb-8f07-17fc8cec2772)
![상승 하락 여부](https://github.com/user-attachments/assets/2aad4f21-4832-4323-bd4b-5814d05f54bc)

## PR

- [Lv 1, 2](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/3)
- [Lv 3, 4, 5](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/7)
- [Lv 6](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/10)
- [Lv 7](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/16)
- [Lv 8](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/20)
- [Lv 9, 10](https://github.com/nbcamp-ch4-team3/ExchangeRateCalculation/pull/22)

## 트러블슈팅

[서치바 관련 트러블슈팅](https://subkyu-ios.tistory.com/42)

## 디버깅 시 참고 사항

SceneDelegate에서 mockDataService, DataService를 바꿔넣을 수 있는데, 맨 처음 디버깅 전에 mockDataService로 설정해주신 다음에 다음 디버깅에서 DataService로 설정해주시면 상승 여부 반영에 대해 보실 수 있습니다.

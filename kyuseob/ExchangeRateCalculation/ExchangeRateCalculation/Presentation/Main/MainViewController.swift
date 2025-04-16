import UIKit

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let searchController = UISearchController()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.configure(dataSource: self, delegate: self)
        searchControllerSetting()
        navigationControllerSetting()

        Task {
            await fetchData()
        }

    }

    private func fetchData() async {
        do {
            try await viewModel.fetchData()
            await MainActor.run {
                mainView.reloadTableView()
            }
        } catch let error as APIError {
            showAlert(message: error.errorMessage)
        } catch {
            showAlert(message: "데이터 로드에 실패했습니다.")
        }
    }

    private func searchControllerSetting() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "통화 검색"
        searchController.searchBar.searchBarStyle = .minimal
    }

    private func navigationControllerSetting() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "환율 정보"
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.identifier) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let currencyItem = viewModel.filteredItems[indexPath.row]

        cell.configure(with: currencyItem)
        print(currencyItem)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText != "" {

        }
    }
}

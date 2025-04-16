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

        configure()
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

    private func navigationControllerSetting() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "환율 정보"
    }
}

private extension MainViewController {
    func configure() {
        mainView.configureTableView(dataSource: self, delegate: self)
        mainView.configureSearchBar(delegate: self)
        navigationControllerSetting()
        hideKeyboardWhenTappedBackground()
    }
    
    func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapEvent.cancelsTouchesInView = false
        view.addGestureRecognizer(tapEvent)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.filterCurrencyItems(by: searchText)
            mainView.reloadTableView()
        } else {
            viewModel.resetFilteredItems()
            mainView.reloadTableView()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

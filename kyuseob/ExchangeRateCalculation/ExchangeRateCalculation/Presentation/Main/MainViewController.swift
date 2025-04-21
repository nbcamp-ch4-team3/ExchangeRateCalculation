import UIKit

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel: MainViewModelProtocol

    override func loadView() {
        view = mainView
    }

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
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
            try viewModel.fetchFavoriteCurrencies()
            try await viewModel.fetchData()
            await MainActor.run {
                mainView.reloadTableView()
            }
        } catch  {
            await MainActor.run {
                showAlert(message: error.localizedDescription)
            }
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
        let count = viewModel.filteredItems.count
        mainView.showEmptyView(count == 0)
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.identifier) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let currencyItem = viewModel.filteredItems[indexPath.row]
        cell.delegate = self
        cell.configure(with: currencyItem)

        let isFavorite = viewModel.isFavorite(currencyCode: currencyItem.code)
        cell.updateFavoriteButtonState(isFavorite: isFavorite)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calculatorViewModel = CalculatorViewModel()
        let vc = CalculatorViewController(viewModel: calculatorViewModel)
        let currencyItem = viewModel.filteredItems[indexPath.row]
        vc.configure(with: currencyItem)
        
        self.navigationController?.pushViewController(vc, animated: false)
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

extension MainViewController: ExchangeRateCellDelegate {
    func didTapFavoriteButton(currencyCode: String) {
        do {
            try viewModel.toggleFavorite(currencyCode: currencyCode)
            mainView.reloadTableView()
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
}

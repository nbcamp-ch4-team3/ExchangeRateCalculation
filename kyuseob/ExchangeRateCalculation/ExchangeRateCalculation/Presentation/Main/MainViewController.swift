import UIKit

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel = MainViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.configure(dataSource: self, delegate: self)

        Task {
            await fetchData()
        }

    }

    private func fetchData() async {
        do {
            try await viewModel.fetchData()
            mainView.reloadTableView()
        } catch let error as APIError {
            showAlert(message: error.errorMessage)
        } catch {
            showAlert(message: "데이터 로드에 실패했습니다.")
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exchangeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRateCell.identifier) as? CurrencyRateCell else {
            return UITableViewCell()
        }

        let currencyCode = viewModel.currencyCodes[indexPath.row]
        guard let rate = viewModel.exchangeData[currencyCode] else { return UITableViewCell() }

        cell.configure(with: currencyCode, rate: rate)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

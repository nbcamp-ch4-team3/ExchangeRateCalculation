import UIKit

final class CalculatorViewController: UIViewController, StateManageable {
    var identifier: String = "CalculatorVC"

    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModelProtocol

    init(viewModel: CalculatorViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calculatorView.delegate = self
    }

    func configure(with: CurrencyInfo) {
        viewModel.setCurrencyInfo(to: with)
        calculatorView.configure(with: with)
    }

    func getStateParams() -> [String : Any]? {
        var params: [String: Any] = [:]

        if let currencyInfo = viewModel.currencyInfo {
            params["currencyCode"] = currencyInfo.code
            params["currencyCountry"] = currencyInfo.country
            params["currencyRate"] = currencyInfo.rate
            params["currencyTrend"] = currencyInfo.trendString
            params["currencyUpdatedDate"] = currencyInfo.updatedDate
        }

        return params
    }

    func restoreState(with params: [String : Any]?) {
        guard let params else { return }

        if let code = params["currencyCode"] as? String,
           let country = params["currencyCountry"] as? String,
           let rate = params["currencyRate"] as? Double,
           let trend = params["currencyTrend"] as? String,
           let updatedDate = params["currencyUpdatedDate"] as? Date {
            let currencyInfo = CurrencyInfo(
                code: code,
                country: country,
                rate: rate,
                trendString: trend,
                updatedDate: updatedDate
            )

            viewModel.setCurrencyInfo(to: currencyInfo)
            calculatorView.configure(with: currencyInfo)
        }
    }
}

extension CalculatorViewController: CalculatorViewDelegate {
    func showError(message: String) {
        showAlert(message: message)
    }
    
    func didTapConvertButton(from: Double) -> String {
        let base = "$\(String(format: "%.2f", from)) → "
        let result = String(format: "%.2f", viewModel.convert(from: from))
        let code = viewModel.currencyInfo?.code

        guard let code else { return "" }

        return "\(base)\(result)\(code)"
    }
}

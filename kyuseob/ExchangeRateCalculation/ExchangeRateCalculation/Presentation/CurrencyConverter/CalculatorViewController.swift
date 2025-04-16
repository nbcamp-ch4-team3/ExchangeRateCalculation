import UIKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
    private let viewModel = CalculatorViewModel()

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

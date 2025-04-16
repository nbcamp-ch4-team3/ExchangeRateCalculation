import UIKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
    private let viewModel = MainViewModel()

    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calculatorView.delegate = self
    }

    func configure(with: CurrencyInfo) {
        calculatorView.configure(with: with)
    }

}

extension CalculatorViewController: CalculatorViewDelegate {
    func didTapConvertButton() -> Double {
        
    }
}

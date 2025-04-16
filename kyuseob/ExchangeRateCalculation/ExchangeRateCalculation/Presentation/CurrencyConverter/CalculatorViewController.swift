import UIKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()

    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

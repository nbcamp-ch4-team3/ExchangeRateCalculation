import UIKit
import SnapKit

protocol CalculatorViewDelegate: AnyObject {
    func didTapConvertButton(from: Double) -> String
    func showError(message: String)
}

final class CalculatorView: UIView {
    weak var delegate: CalculatorViewDelegate?

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        return stackView
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "AAA"

        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.text = "임시국가명"

        return label
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.placeholder = "금액을 입력하세요"

        return textField
    }()

    private let convertButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("환율 계산", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8

        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "결과가 여기에 표시됩니다"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with: CurrencyInfo) {
        currencyLabel.text = with.code
        countryLabel.text = with.country
    }
}

private extension CalculatorView {
    func configure() {
        setHierarchy()
        setConstraints()
        setAction()
    }

    func setHierarchy() {
        addSubViews(views: labelStackView, amountTextField, convertButton, resultLabel)
        labelStackView.addArrangedSubViews(views: currencyLabel, countryLabel)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }

    func setAction() {
        convertButton.addTarget(self, action: #selector(didTapConvertButton), for: .touchUpInside)
    }

    @objc func didTapConvertButton() {
        if let text = amountTextField.text, text.isEmpty {
            delegate?.showError(message: "금액을 입력해주세요")
            return
        }

        guard let amount = amountTextField.text, let inputValue = Double(amount) else {
            delegate?.showError(message: "올바른 숫자를 입력해주세요")
            return
        }

        guard let result = delegate?.didTapConvertButton(from: inputValue) else { return }
        self.resultLabel.text = result
    }
}

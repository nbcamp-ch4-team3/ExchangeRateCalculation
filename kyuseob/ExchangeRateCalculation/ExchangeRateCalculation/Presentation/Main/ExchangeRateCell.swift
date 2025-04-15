import UIKit

class ExchangeRateCell: UITableViewCell {
    static let identifier = "CurrencyRateCell"

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label

        return label
    }()

    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .right

        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with: String, rate: Double, country: String) {
        self.currencyCodeLabel.text = with
        let formattedRate = String(format: "%.4f", rate)
        self.exchangeRateLabel.text = formattedRate
        self.countryLabel.text = country
    }
}

private extension ExchangeRateCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        contentView.backgroundColor = .systemBackground
        self.selectionStyle = .none
    }

    func setHierarchy() {
        contentView.addSubViews(views: labelStackView, exchangeRateLabel)
        labelStackView.addArrangedSubViews(views: currencyCodeLabel, countryLabel)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }

    }
}

import UIKit

class CurrencyRateCell: UITableViewCell {
    static let identifier = "CurrencyRateCell"

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label

        return label
    }()

    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label

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

    func configure(with: String, rate: Double) {
        self.currencyCodeLabel.text = with
        let formattedRate = String(format: "%.4f", rate)
        self.exchangeRateLabel.text = formattedRate
    }
}

private extension CurrencyRateCell {
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
        [currencyCodeLabel, exchangeRateLabel].forEach { contentView.addSubview($0) }
    }

    func setConstraints() {
        currencyCodeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.directionalVerticalEdges.equalToSuperview().inset(10)
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}

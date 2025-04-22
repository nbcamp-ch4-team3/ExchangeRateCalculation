import UIKit

protocol ExchangeRateCellDelegate: AnyObject {
    func didTapFavoriteButton(currencyCode: String)
}

final class ExchangeRateCell: UITableViewCell {
    static let identifier = "CurrencyRateCell"
    private var currencyCode: String = ""
    weak var delegate: ExchangeRateCellDelegate?

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

    private let trendLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with: CurrencyInfo) {
        self.currencyCodeLabel.text = with.code
        self.exchangeRateLabel.text = with.formattedRate
        self.countryLabel.text = with.country
        self.currencyCode = with.code
        self.trendLabel.text = {
            switch with.trend {
            case .up:
                return "🔼"
            case .down:
                return "🔽"
            case .unchanged:
                return "⏸️"
            case .new:
                return "🆕"
            }
        }()
    }

    func updateFavoriteButtonState(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

private extension ExchangeRateCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setAction()
    }

    func setLayout() {
        contentView.backgroundColor = .systemBackground
        self.selectionStyle = .none
    }

    func setHierarchy() {
        contentView.addSubViews(views: labelStackView, exchangeRateLabel, trendLabel, favoriteButton)
        labelStackView.addArrangedSubViews(views: currencyCodeLabel, countryLabel)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }

        trendLabel.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.trailing.equalTo(trendLabel.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
    }

    func setAction() {
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }

    @objc private func didTapFavoriteButton() {
        delegate?.didTapFavoriteButton(currencyCode: currencyCode)
    }
}

import UIKit
import SnapKit

class MainView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier)
        tableView.allowsMultipleSelection = false

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    func reloadTableView() {
        tableView.reloadData()
    }

}

private extension MainView {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        backgroundColor = .systemBackground
    }

    func setHierarchy() {
        addSubViews(views: tableView)
    }

    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}

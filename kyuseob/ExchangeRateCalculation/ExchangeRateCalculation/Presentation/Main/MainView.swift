import UIKit
import SnapKit

class MainView: UIView {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .default
        searchBar.showsCancelButton = false

        return searchBar
    }()

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

    func configureTableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    func configureSearchBar(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
        addSubViews(views: searchBar, tableView)
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

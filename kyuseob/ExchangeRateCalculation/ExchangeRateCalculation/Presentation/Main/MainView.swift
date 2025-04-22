import UIKit
import SnapKit

final class MainView: UIView {
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

    private let emptyView = EmptyView()

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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showEmptyView(_ show: Bool) {
        emptyView.isHidden = !show
    }

    func searchText() -> String? {
        return searchBar.text
    }

    func setSearchText(to searchText: String) {
        searchBar.text = searchText
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
        addSubViews(views: searchBar, tableView, emptyView)
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
}

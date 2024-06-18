import UIKit

final class UserNftViewController: UIViewController {

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private var nfts: [Nft] = []

    private var presenter: NftPresenter

    private lazy var chevronLeft: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?
            .withTintColor(.textColor, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort")?
            .withTintColor(.textColor, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return button
    }()

    private lazy var nftsTable: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileUserNftCell.self, forCellReuseIdentifier: ProfileUserNftCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = .bodyBold
        label.textColor = .textColor
        label.isHidden = true
        return label
    }()

    // MARK: - Init

    init(presenter: NftPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        setupUI()
    }
}

extension UserNftViewController {

    private func setupUI() {
        title = "Мои NFT"

        let backButton = UIBarButtonItem(customView: chevronLeft)
        navigationItem.leftBarButtonItem = backButton

        let sortButton = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = sortButton

        [nftsTable, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        nftsTable.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: nftsTable)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            nftsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] (_) in
            guard let self else { return }

            self.presenter.sortByPrice(nfts: self.nfts)
        }))

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] (_) in
            guard let self else { return }

            self.presenter.sortByRating(nfts: self.nfts)
        }))

        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] (_) in
            guard let self else { return }

            self.presenter.sortByName(nfts: self.nfts)
        }))

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { (_) in
        }))

        self.present(alert, animated: true)
    }
}

// MARK: - UserNFTsView

extension UserNftViewController: NftView {

    func fetchNfts(_ nft: [Nft]) {
        self.nfts = nft

        if self.nfts.count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
            nftsTable.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension UserNftViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileUserNftCell.identifier,
            for: indexPath) as? ProfileUserNftCell else {
            return UITableViewCell()
        }

        let nft = nfts[indexPath.row]
        cell.updateCell(with: nft)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

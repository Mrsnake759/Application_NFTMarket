import UIKit

// MARK: - Protocol
protocol UserNftsViewProtocol: AnyObject, ErrorView, LoadingView {
    func displayUserNfts()
}

final class UserNftsViewController: UIViewController {

    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    private let presenter: UserNftsPresenterProtocol

    // MARK: - UI elements
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .systemBackground

        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem =  UIBarButtonItem(customView: backButton)
        navItem.title = NSLocalizedString("UserInfo.nftCollections", comment: "")
        navBar.setItems([navItem], animated: false)

        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)

        return navBar
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var userNftsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserNftCell.self)
        collectionView.backgroundColor = .background
        return collectionView
    }()

    // MARK: - Init
    init(presenter: UserNftsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }

    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }

    // MARK: - Layout
    private func setupViews() {

        [navigationBar, backButton, userNftsCollectionView].forEach {
             view.addSubview($0)
             $0.translatesAutoresizingMaskIntoConstraints = false
           }

        view.backgroundColor = .background
        view.addSubview(navigationBar)
        view.addSubview(userNftsCollectionView)
        userNftsCollectionView.addSubview(activityIndicator)
        userNftsCollectionView.dataSource = self
        userNftsCollectionView.delegate = self
    }

    private func setupConstraints() {
        activityIndicator.constraintCenters(to: userNftsCollectionView)
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userNftsCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            userNftsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNftsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNftsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UserNftsViewProtocol
extension UserNftsViewController: UserNftsViewProtocol {
    func displayUserNfts() {
        userNftsCollectionView.reloadData()
    }
}

// MARK: - UserNftCellDelegate
extension UserNftsViewController: UserNftCellDelegate {
    func cellDidTapLike(_ cell: UserNftCell) {
        guard let indexPath = userNftsCollectionView.indexPath(for: cell) else { return }
        presenter.updateLike(cell, index: indexPath.row)
        userNftsCollectionView.reloadItems(at: [indexPath])
    }

    func cellDidTapBasket(_ cell: UserNftCell) {
        guard let indexPath = userNftsCollectionView.indexPath(for: cell) else { return }
        presenter.updateOrder(cell, index: indexPath.row)
        userNftsCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionView Protocols
extension UserNftsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.userNftsCellModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserNftCell = userNftsCollectionView.dequeueReusableCell(indexPath: indexPath)
        let userNftCell = presenter.userNftsCellModel[indexPath.row]
        cell.configure(with: userNftCell)
        cell.delegate = self
        return cell
    }
}

extension UserNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 18) / 3, height: 192)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

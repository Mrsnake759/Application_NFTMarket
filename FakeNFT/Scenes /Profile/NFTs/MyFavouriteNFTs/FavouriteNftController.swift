//
//  MyFavouriteNFTsController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 12/05/24.
//

import UIKit

protocol BackButtonDelegate: AnyObject {
    func didTapBackButton(for nftIds: [String])
}

final class FavouriteNftViewController: UIViewController {
    weak var delegate: BackButtonDelegate?

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private var nfts: [Nft] = []

    private var unlikeNftIds: [String] = []

    private var presenter: NftPresenter

    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 7)

    private lazy var chevronLeft: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?
            .withTintColor(.textColor, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private let nftsCollection: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.isScrollEnabled = false

        collectionView.register(
            FavouriteNftsCell.self,
            forCellWithReuseIdentifier: FavouriteNftsCell.identifier)

        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .background
        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
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

extension FavouriteNftViewController {

    private func setupUI() {
        view.backgroundColor = .background
        title = "Избранные NFT"

        let backButton = UIBarButtonItem(customView: chevronLeft)
        navigationItem.leftBarButtonItem = backButton

        nftsCollection.delegate = self
        nftsCollection.dataSource = self

        [nftsCollection, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        nftsCollection.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: nftsCollection)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            nftsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        delegate?.didTapBackButton(for: unlikeNftIds)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UserNFTsView

extension FavouriteNftViewController: NftView {

    func fetchNfts(_ nft: [Nft]) {
        self.nfts = nft

        if self.nfts.count != 0 {
            emptyLabel.isHidden = true
            nftsCollection.reloadData()
        } else {
            emptyLabel.isHidden = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavouriteNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavouriteNftsCell.identifier,
            for: indexPath) as? FavouriteNftsCell else {
            return UICollectionViewCell()
        }

        let nft = nfts[indexPath.item]
        cell.updateCell(with: nft)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavouriteNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth,
                      height: 108)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
}

extension FavouriteNftViewController: FavouriteNftsCellDelegate {
    func didTapLike(_ cell: FavouriteNftsCell) {
        guard let indexPath = nftsCollection.indexPath(for: cell) else { return }

        let nft = nfts.remove(at: indexPath.row)
        unlikeNftIds.append(nft.id)

        nftsCollection.reloadData()
    }
}

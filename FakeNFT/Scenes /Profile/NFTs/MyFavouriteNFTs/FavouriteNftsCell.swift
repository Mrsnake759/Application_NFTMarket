import UIKit
import Kingfisher

protocol FavouriteNftsCellDelegate: AnyObject {
    func didTapLike(_ cell: FavouriteNftsCell)
}

final class FavouriteNftsCell: UICollectionViewCell {

    static let identifier = "FavouriteNftCell"

    weak var delegate: FavouriteNftsCellDelegate?

    private var id: String?

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Favourite"), for: .normal)
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textColor
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var starImageView: RatingView = {
        let starImageView = RatingView()
        return starImageView
    }()

    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell(with nft: Nft) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)

        cardImageView.kf.indicatorType = .activity

        cardImageView.kf.setImage(
            with: nft.images.first,
            options: [.processor(processor),
                      .cacheMemoryOnly
            ]
        )

        nftNameLabel.text = nft.name
        starImageView.setStar(with: nft.rating)
        moneyLabel.text = "\(nft.price) ETH"
    }
}

extension FavouriteNftsCell {
    private func setupUI() {
        contentView.backgroundColor = .background
        [cardImageView, likeButton, nftNameLabel, starImageView, moneyLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardImageView.heightAnchor.constraint(equalToConstant: 80),
            cardImageView.widthAnchor.constraint(equalToConstant: 80),
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),

            nftNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 12),
            nftNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nftNameLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -8),

            starImageView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            starImageView.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),

            moneyLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            moneyLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8)
        ])
    }

    @objc private func didTapLike() {
        delegate?.didTapLike(self)
    }
}

import Kingfisher
import UIKit

final class StatisticsTableCell: UITableViewCell, ReuseIdentifying {

    static let defaultReuseIdentifier = "statisticsCell"

    // MARK: - UI elements
    private lazy var ratingPositionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textColor
        return label
    }()

    private let infoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .segmentInactive
        return view
    }()

    private lazy var userAvatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textColor
        label.numberOfLines = 2
        return label
    }()

    private lazy var countsNFTLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textColor
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    // MARK: - Layout

    private func setupViews() {
        backgroundColor = .background

        contentView.addSubview(ratingPositionLabel)
        contentView.addSubview(infoView)
        infoView.addSubview(userAvatarImage)
        infoView.addSubview(userNameLabel)
        infoView.addSubview(countsNFTLabel)
    }

    private func setupConstraints() {

        [ratingPositionLabel, infoView, userAvatarImage, userNameLabel, countsNFTLabel].forEach {
              contentView.addSubview($0)
              $0.translatesAutoresizingMaskIntoConstraints = false
          }

        NSLayoutConstraint.activate([
            ratingPositionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingPositionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            infoView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            infoView.leadingAnchor.constraint(equalTo: ratingPositionLabel.trailingAnchor, constant: 8),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            userAvatarImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 28),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 28),
            userAvatarImage.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.trailingAnchor, constant: 8),
            userNameLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),

            countsNFTLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),
            countsNFTLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
    }

    // MARK: - Functions

    func configure(with cellModel: UserCellModel, cellNumber: Int) {

        ratingPositionLabel.text = "\(cellNumber)"

        userAvatarImage.kf.setImage(with: cellModel.avatar)

        userNameLabel.text = cellModel.name

        countsNFTLabel.text = String(cellModel.nfts.count)
    }
}

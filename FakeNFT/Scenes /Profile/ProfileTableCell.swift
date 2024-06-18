//
//  TableCell.swift
//  FakeNFT
//
//  Created by Irina Deeva on 12/05/24.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "ProfileTableViewCellIdentifier"

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = .bodyBold
        return label
    }()

    private lazy var chevronRight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .textColor
        return imageView
    }()

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .background

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

     func configureCell(text: String) {
         cellLabel.text = text
    }

    private func setupUI() {

        [cellLabel, chevronRight].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            chevronRight.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronRight.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

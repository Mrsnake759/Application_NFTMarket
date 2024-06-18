//
//  EditProfileDetails.swift
//  FakeNFT
//
//  Created by Irina Deeva on 08/05/24.
//

import UIKit
import Kingfisher

protocol EditProfileDetailsView: AnyObject, ErrorView, LoadingView {
    func fetchProfileDetails(_ profile: Profile)
    func dismissView()
}

protocol EditProfileDetailsViewDelegate: AnyObject {
    func didTapClose()
}

final class EditProfileDetailsViewController: UIViewController {

    weak var delegate: EditProfileDetailsViewDelegate?

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private let presenter: EditProfileDetailsPresenter

    private var profileAvatar: String?

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .closeButton
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()

    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()

    private lazy var stubEditLabel: UILabel = {
        let label = UILabel()
        label.text = "Сменить\n фото"
        label.textColor = .yaUniversalWhite
        label.font = .small
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var imageEditMode: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 35
        uiView.layer.masksToBounds = true
        uiView.backgroundColor = .profileEditMode
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        uiView.addGestureRecognizer(tapGR)
        uiView.isUserInteractionEnabled = true
        uiView.isHidden = true
        return uiView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.textColor = .textColor
        label.font = .headline3
        label.isHidden = true
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .textColor
        label.font = .headline3
        label.isHidden = true
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.textColor = .textColor
        label.font = .headline3
        label.isHidden = true
        return label
    }()

    private var nameTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.textColor = .textColor
        textField.font = .bodyRegular
        textField.backgroundColor = .segmentInactive
        textField.layer.cornerRadius = 12
        textField.textAlignment = .left
        textField.isHidden = true
        return textField
    }()

    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .textColor
        textView.font = .bodyRegular
        textView.backgroundColor = .segmentInactive
        textView.layer.cornerRadius = 12
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.isHidden = true
        return textView
    }()

    private var websiteTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.textColor = .textColor
        textField.font = .bodyRegular
        textField.backgroundColor = .segmentInactive
        textField.layer.cornerRadius = 12
        textField.textAlignment = .left
        textField.isHidden = true
        return textField
    }()

    // MARK: - Init

    init(presenter: EditProfileDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }
}

extension EditProfileDetailsViewController {

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .background

        nameTextField.delegate = self
        websiteTextField.delegate = self
        descriptionTextView.delegate = self

        imageEditMode.addSubview(stubEditLabel)
        stubEditLabel.translatesAutoresizingMaskIntoConstraints = false

        [closeButton,
         profileImage,
         imageEditMode,
         nameLabel,
         descriptionLabel,
         websiteLabel,
         nameTextField,
         descriptionTextView,
         websiteTextField]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            imageEditMode.heightAnchor.constraint(equalToConstant: 70),
            imageEditMode.widthAnchor.constraint(equalToConstant: 70),
            imageEditMode.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            imageEditMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stubEditLabel.leadingAnchor.constraint(equalTo: imageEditMode.leadingAnchor, constant: 11),
            stubEditLabel.trailingAnchor.constraint(equalTo: imageEditMode.trailingAnchor, constant: -11),
            stubEditLabel.centerYAnchor.constraint(equalTo: imageEditMode.centerYAnchor),
            stubEditLabel.centerXAnchor.constraint(equalTo: imageEditMode.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),

            descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),

            websiteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            websiteLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),

            websiteTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            websiteTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func updateProfileImage() {
        if let avatar = profileAvatar {
            let processor = RoundCornerImageProcessor(cornerRadius: 61)
            let placeholder = UIImage(named: "ProfileStub")

            profileImage.kf.indicatorType = .activity

            profileImage.kf.setImage(
                with: URL(string: avatar),
                placeholder: placeholder,
                options: [.processor(processor),
                          .cacheMemoryOnly
                ]
            )
        } else {
            profileImage.image = UIImage(named: "ProfileStub")
        }
    }

    @objc private func didTapClose() {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let website = websiteTextField.text,
              let avatar = profileAvatar
        else {
            return
        }

        let updatedProfile = ProfileToUpload(
            name: name,
            description: description,
            website: website,
            avatar: avatar
        )

        presenter.updateProfile(with: updatedProfile)
    }

    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let alertController =
        UIAlertController(title: "Введите ссылку",
                          message: "вставьте ссылку на новое изображение",
                          preferredStyle: .alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "ULR"
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let link = alertController.textFields?.first?.text {
                self?.profileAvatar = link
                self?.updateProfileImage()
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - EditProfileDetailsView

extension EditProfileDetailsViewController: EditProfileDetailsView {

    func fetchProfileDetails(_ profile: Profile) {
        [profileImage,
         imageEditMode,
         nameLabel,
         descriptionLabel,
         websiteLabel,
         nameTextField,
         descriptionTextView,
         websiteTextField].forEach {
            $0.isHidden = false
        }

        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        profileAvatar =  profile.avatar

        updateProfileImage()
    }

    func dismissView() {
        delegate?.didTapClose()
        dismiss(animated: true)
    }
}

extension EditProfileDetailsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else {
            return false
        }

        let text = currentText.replacingCharacters(in: range, with: string)

        if !text.isEmpty {
            closeButton.isUserInteractionEnabled = true
            closeButton.alpha = 1.0
        } else {
            closeButton.isUserInteractionEnabled = false
            closeButton.alpha = 0.5
        }

        return true
    }
}

extension EditProfileDetailsViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            closeButton.isUserInteractionEnabled = true
            closeButton.alpha = 1.0
        } else {
            closeButton.isUserInteractionEnabled = false
            closeButton.alpha = 0.5
        }
    }

}

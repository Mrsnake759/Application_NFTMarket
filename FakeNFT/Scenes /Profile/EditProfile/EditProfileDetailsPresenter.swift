//
//  EditProfileDetailsPresenter.swift
//  FakeNFT
//
//  Created by Irina Deeva on 09/05/24.
//

import Foundation

// MARK: - Protocol

protocol EditProfileDetailsPresenter {
    func viewDidLoad()
    func updateProfile(with profileToUpload: ProfileToUpload)
}

// MARK: - State

enum EditProfileDetailState {
    case initial, loading, failed(Error), data(Profile), updating(ProfileToUpload), update(Profile)
}

final class EditProfileDetailsPresenterImpl: EditProfileDetailsPresenter {

    // MARK: - Properties
    weak var view: EditProfileDetailsView?
    private let service: ProfileService
    private var state = EditProfileDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(service: ProfileService) {
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadProfile()
        case .data(let profile):
            view?.fetchProfileDetails(profile)
            view?.hideLoading()
        case .updating(let profileToUpload):
            view?.showLoading()
            upload(with: profileToUpload)
        case .update(let profile):
            view?.hideLoading()
            view?.dismissView()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    func updateProfile(with profileToUpload: ProfileToUpload) {
        state = .updating(profileToUpload)
    }

    private func upload(with profileToUpload: ProfileToUpload) {
        service.uploadProfile(with: profileToUpload) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .update(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func loadProfile() {
        service.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .data(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}

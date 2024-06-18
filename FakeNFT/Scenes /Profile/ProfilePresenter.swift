//
//  ProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

// MARK: - Protocol

protocol ProfilePresenter {
    func viewDidLoad()
    func viewDidUpdate()
    func removeFromFavourite(for nftIds: [String])
    func fetchTitleForCell(with indexPath: IndexPath) -> String
    func fetchUserNFTsPresenter() -> NftPresenterImpl
    func fetchFavouriteNFTsPresenter() -> NftPresenterImpl
    func fetchProfileService() -> ProfileService
}

// MARK: - State

enum ProfileDetailState {
    case initial,
         loading,
         failed(Error),
         data(Profile),
         updating,
         update(Profile),
         removeNfts([String]),
         updateTable
}

final class ProfilePresenterImpl: ProfilePresenter {

    // MARK: - Properties

    weak var view: ProfileDetailsView?
    private let profileService: ProfileService
    private let nftService: NftService
    private var state = ProfileDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    private var userNFTsIds: [String] = []
    private var favouriteNFTsIds: [String] = []

    // MARK: - Init

    init(profileService: ProfileService, nftService: NftService) {
        self.profileService = profileService
        self.nftService = nftService
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    func viewDidUpdate() {
        state = .updating
    }

    func removeFromFavourite(for nftIds: [String]) {
        state = .removeNfts(nftIds)
    }

    func fetchTitleForCell(with indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return "Мои NFT (\(userNFTsIds.count))"
        case 1:
            return "Избранные NFT (\(favouriteNFTsIds.count))"
        case 2:
            return "О разработчике"
        default:
            return ""
        }
    }

    func fetchUserNFTsPresenter() -> NftPresenterImpl {
        let presenter = NftPresenterImpl(
            input: NftsInput(id: userNFTsIds),
            service: nftService
        )

        return presenter
    }

    func fetchFavouriteNFTsPresenter() -> NftPresenterImpl {
        let presenter = NftPresenterImpl(
            input: NftsInput(id: favouriteNFTsIds),
            service: nftService
        )

        return presenter
    }

    func fetchProfileService() -> ProfileService {
        profileService
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadProfile()
        case .data(let profile):
            userNFTsIds = profile.nfts
            favouriteNFTsIds = profile.likes
            view?.fetchProfileDetails(profile)
            view?.hideLoading()
        case .updating:
            updateProfile()
        case .update(let profile):
            view?.fetchProfileDetails(profile)
        case .removeNfts(let nfts):
            updateFavourites(with: nfts)
        case .updateTable:
            view?.updateTable()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func updateFavourites(with nftIds: [String]) {
        profileService.updateFavourites(with: nftIds) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.favouriteNFTsIds = profile.likes
                self?.state = .updateTable
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func updateProfile() {
        profileService.updateProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .update(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func loadProfile() {
        profileService.loadProfile { [weak self] result in
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

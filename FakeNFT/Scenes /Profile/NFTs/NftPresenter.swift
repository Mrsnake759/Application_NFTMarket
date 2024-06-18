import Foundation

// MARK: - Protocol

protocol NftPresenter {
    func viewDidLoad()
    func sortByPrice(nfts: [Nft])
    func sortByRating(nfts: [Nft])
    func sortByName(nfts: [Nft])
}

// MARK: - State

enum UserNftState {
    case initial, loading, failed(Error), data([Nft])
}

final class NftPresenterImpl: NftPresenter {

    // MARK: - Properties

    weak var view: NftView?
    private let input: NftsInput
    private let service: NftService
    private var state = UserNftState.initial {
        didSet {
            stateDidChanged()
        }
    }

    private let filterKey = "filter"

    init(input: NftsInput, service: NftService) {
        self.input = input
        self.service = service
    }

    func viewDidLoad() {
        state = .loading
    }

    func sortByPrice(nfts: [Nft]) {
        let sortedNfts = nfts.sorted {
            $0.price < $1.price
        }
        view?.fetchNfts(sortedNfts)
    }

    func sortByRating(nfts: [Nft]) {
        let sortedNfts = nfts.sorted {
            $0.rating > $1.rating
        }
        view?.fetchNfts(sortedNfts)
    }

    func sortByName(nfts: [Nft]) {
        let sortedNfts = nfts.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
    }
        view?.fetchNfts(sortedNfts)
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNft()
        case .data(let nfts):
            view?.fetchNfts(nfts)
            view?.hideLoading()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func loadNft() {
        var loadedNfts: [Nft] = []

        let group = DispatchGroup()

        for id in input.id {
            group.enter()
            service.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    self?.state = .failed(error)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.state = .data(loadedNfts)
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

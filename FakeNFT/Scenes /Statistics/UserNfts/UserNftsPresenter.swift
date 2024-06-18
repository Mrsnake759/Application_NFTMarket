import Foundation

// MARK: - Protocol

protocol UserNftsPresenterProtocol {
    var userNftsCellModel: [UserNftCellModel] { get set }
    func viewDidLoad()
    func updateLike(_ cell: UserNftCell, index: Int)
    func updateOrder(_ cell: UserNftCell, index: Int)
}

// MARK: - State

enum UserNftsState {
    case initial, loading, data, failed(Error)
}

final class UserNftsPresenter: UserNftsPresenterProtocol {

    // MARK: - Properties
    weak var view: UserNftsViewProtocol?
    var userNftsCellModel = [UserNftCellModel]()

    private var likesProfile = [String]()
    private var ordersProfile = [String]()
    private var userNfts = [UserNft]()

    private let nftsInput: [String]
    private let userNftService: UserNftsServiceProtocol
    private let likeService: LikesServiceProtocol
    private let orderService: OrdersServiceProtocol

    private var state = UserNftsState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init
    init(
        nftsInput: [String],
        userNftService: UserNftsServiceProtocol,
        likeService: LikesServiceProtocol,
        orderService: OrdersServiceProtocol
    ) {
        self.nftsInput = nftsInput
        self.userNftService = userNftService
        self.likeService = likeService
        self.orderService = orderService
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
            view?.showLoadingAndBlockUI()
            loadLikesProfile()
            loadOrdersProfile()
            loadUserNfts()
        case .data:
            view?.hideLoadingAndUnblockUI()
            setLikesAndOrders()
            view?.displayUserNfts()
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }

    private func loadUserNfts() {
        if !nftsInput.isEmpty {
            userNftService.loadNfts(with: nftsInput, completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let nfts):
                    self.userNfts = nfts
                    if self.nftsInput.count == self.userNfts.count {
                        self.state = .data
                    }
                case .failure(let error):
                    self.state = .failed(error)
                }
            })
        } else {
            view?.hideLoadingAndUnblockUI()
        }
    }

    private func loadLikesProfile() {
        likeService.getLikes(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let likes):
                self.likesProfile = likes.likes
            case .failure(let error):
                self.state = .failed(error)
            }
        })
    }

    private func loadOrdersProfile() {
        orderService.getOrders(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let orders):
                self.ordersProfile = orders.nfts
            case .failure(let error):
                self.state = .failed(error)
            }
        })
    }

    private func setLikesAndOrders() {
        for nft in userNfts {

            let like = likesProfile.first { like in
                return like == nft.id
            } != nil

            let order = ordersProfile.first { order in
                return order == nft.id
            } != nil

            let nftCell = convertToNftCellModel(from: nft, like: like, order: order)
            userNftsCellModel.append(nftCell)
        }
    }

    private func convertToNftCellModel(from nft: UserNft, like: Bool, order: Bool) -> UserNftCellModel {
        let cell = UserNftCellModel(
            id: nft.id,
            name: nft.name,
            image: nft.images.first,
            price: String(nft.price),
            rating: nft.rating,
            like: like,
            order: order
        )
        return cell
    }

    func updateLike(_ cell: UserNftCell, index: Int) {
        userNftsCellModel[index].changeLike()
        let nft = userNftsCellModel[index]
        updateLikes(to: cell, by: nft.like, nftId: nft.id)
    }

    private func updateLikes(to cell: UserNftCell, by like: Bool, nftId: String) {
        switch like {
        case true:
            likesProfile.append(nftId)
        case false:
            likesProfile.removeAll(where: {
                $0 == nftId
            })
        }
        putLikes(cell: cell, like: like)
    }

    private func putLikes(cell: UserNftCell, like: Bool) {
        likeService.putLikes(likes: likesProfile) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let likes):
                self.likesProfile = likes.likes
                cell.setLike(to: like)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    func updateOrder(_ cell: UserNftCell, index: Int) {
        userNftsCellModel[index].changeOrder()
        let nft = userNftsCellModel[index]
        updateOrders(to: cell, by: nft.order, nftId: nft.id)
    }

    private func updateOrders(to cell: UserNftCell, by order: Bool, nftId: String) {
        switch order {
        case true:
            ordersProfile.append(nftId)
        case false:
            ordersProfile.removeAll(where: {
                $0 == nftId
            })
        }
        putOrders(cell: cell, order: order)
    }

    private func putOrders(cell: UserNftCell, order: Bool) {
        orderService.putOrders(orders: ordersProfile) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let orders):
                self.ordersProfile = orders.nfts
                cell.setBasket(to: order)
            case .failure(let error):
                self.state = .failed(error)
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
            self?.userNftsCellModel = [UserNftCellModel]()
            self?.state = .loading
        }
    }
}

import UIKit

final class UserNftsAssembly {

    private let networkClient = DefaultNetworkClient()

    private var userNftService: UserNftsServiceProtocol {
        UserNftsService(
            networkClient: networkClient
        )
    }

    private var likeService: LikesServiceProtocol {
        LikesService(
            networkClient: networkClient
        )
    }

    private var orderService: OrdersServiceProtocol {
        OrdersService(
            networkClient: networkClient
        )
    }

    func build(with input: [String]) -> UIViewController {
        let presenter = UserNftsPresenter(
            nftsInput: input,
            userNftService: userNftService,
            likeService: likeService,
            orderService: orderService
        )
        let viewController = UserNftsViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}

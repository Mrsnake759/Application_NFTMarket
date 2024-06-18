final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage
    private let profileStorage: ProfileStorage
    private let orderStorage: OrderStorageProtocol
    private let nftByIdStorage: NftByIdStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage,
        profileStofare: ProfileStorage,
        orderStorage: OrderStorageProtocol,
        nftByIdStorage: NftByIdStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
        self.profileStorage = profileStofare
        self.orderStorage = orderStorage
        self.nftByIdStorage = nftByIdStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var statisticsService: UsersServiceProtocol {
        UsersService(
            networkClient: networkClient,
            storage: usersStorage
        )
    }

    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            storage: profileStorage
        )
    }

    var orderService: OrderServiceProtocol {
        CartOrderService(
            networkClient: networkClient,
            orderStorage: orderStorage,
            nftByIdService: nftByIdService,
            nftStorage: nftByIdStorage)
    }

    var nftByIdService: NftByIdServiceProtocol {
        NftByIdService(
            networkClient: networkClient,
            storage: nftByIdStorage)
    }

    var payService: PayServiceProtocol {
        PayService(
            networkClient: networkClient
        )
    }
}

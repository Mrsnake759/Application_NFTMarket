import Foundation

typealias UserNftCompletion = (Result<UserNft, Error>) -> Void
typealias UserNftsCompletion = (Result<[UserNft], Error>) -> Void

// MARK: - Protocol
protocol UserNftsServiceProtocol {
    func loadUserNft(with id: String, completion: @escaping UserNftCompletion)
    func loadNfts(with nftsID: [String], completion: @escaping UserNftsCompletion)
}

final class UserNftsService: UserNftsServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUserNft(with id: String, completion: @escaping UserNftCompletion) {

        let request = UserNftRequest(id: id)

        networkClient.send(request: request, type: UserNft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNfts(with nftsID: [String], completion: @escaping UserNftsCompletion) {
        var nfts = [UserNft]()
        nftsID.forEach {
            self.loadUserNft(with: $0) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                    if nfts.count == nftsID.count {
                        completion(.success(nfts))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

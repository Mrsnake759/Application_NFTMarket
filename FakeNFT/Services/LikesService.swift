import Foundation

typealias LikesCompletion = (Result<Likes, Error>) -> Void

// MARK: - Protocol
protocol LikesServiceProtocol {
    func getLikes(completion: @escaping LikesCompletion)
    func putLikes(likes: [String], completion: @escaping LikesCompletion)
}

final class LikesService: LikesServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getLikes(completion: @escaping LikesCompletion) {

        let request = GetLikesRequest()

        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putLikes(likes: [String], completion: @escaping LikesCompletion) {
        let request = PutLikesRequest(likes: likes)

        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

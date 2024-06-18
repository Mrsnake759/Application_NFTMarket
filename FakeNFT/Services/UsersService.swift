import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

// MARK: - Protocol
protocol UsersServiceProtocol {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UsersService: UsersServiceProtocol {

    private let storage: UsersStorage
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()

        networkClient.send(request: request, type: [User].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

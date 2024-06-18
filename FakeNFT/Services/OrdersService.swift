import Foundation

typealias OrdersCompletion = (Result<Orders, Error>) -> Void

// MARK: - Protocol
protocol OrdersServiceProtocol {
    func getOrders(completion: @escaping OrdersCompletion)
    func putOrders(orders: [String], completion: @escaping OrdersCompletion)
}

final class OrdersService: OrdersServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getOrders(completion: @escaping OrdersCompletion) {

        let request = GetOrdersRequest()

        networkClient.send(request: request, type: Orders.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putOrders(orders: [String], completion: @escaping OrdersCompletion) {

        let request = PutOrdersRequest(orders: orders)

        networkClient.send(request: request, type: Orders.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

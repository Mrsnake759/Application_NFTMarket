import Foundation

struct GetOrdersRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct PutOrdersRequest: NetworkRequest {
    var dto: Data? {
        return params.data(using: .utf8)
    }

    var orders: [String]

    var params: String {
        var params = ""
        orders.forEach {
            params += "nfts=" + $0 + "&"
        }
        params.removeLast()
        return params
    }

    var httpMethod: HttpMethod { .put }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

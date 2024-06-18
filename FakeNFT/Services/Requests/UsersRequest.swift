import Foundation

struct UsersRequest: NetworkRequest {
    var dto: Data?

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
}

struct UserInfoRequest: NetworkRequest {
    var dto: Data?

    let id: String

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}

struct UserNftRequest: NetworkRequest {
    var dto: Data?

    let id: String

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

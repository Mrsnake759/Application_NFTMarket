import Foundation

struct GetLikesRequest: NetworkRequest {
    var dto: Data?

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct PutLikesRequest: NetworkRequest {
    var dto: Data? {
        return params.data(using: .utf8)
    }

    var likes: [String]

    var params: String {
        var params = ""
        likes.forEach {
            params += "likes=" + $0 + "&"
        }
        params.removeLast()
        return params
    }

    var httpMethod: HttpMethod { .put }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

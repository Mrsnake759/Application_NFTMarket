import Foundation

struct NFTRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

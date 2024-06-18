import Foundation

struct ExampleRequest: NetworkRequest {
    var httpMethod: HttpMethod

    var dto: Data?

    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}

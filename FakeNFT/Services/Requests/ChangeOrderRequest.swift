//
//  ChangeOrderRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 20.05.2024.
//

import Foundation

struct ChangeOrderRequest: NetworkRequest {
    var dto: Data? {
        return params.data(using: .utf8)
    }

    var httpMethod: HttpMethod { .put }
    var nfts: [String]?

    var params: String {
        var params = ""
        guard let nfts else {
            return params
        }

        nfts.forEach {
            params += "nfts=" + $0 + "&"
        }
        params.removeLast()
        return params
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    init(nfts: [String]) {
        self.nfts = nfts
    }
}

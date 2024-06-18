//
//  PayRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation

struct PayRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    let currencyId: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }

    var nfts: [String]?
}

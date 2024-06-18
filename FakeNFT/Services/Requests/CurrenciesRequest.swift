//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")

    }
    var nfts: [String]?
}

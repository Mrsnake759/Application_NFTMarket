//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var httpMethod: HttpMethod

    var dto: Data?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

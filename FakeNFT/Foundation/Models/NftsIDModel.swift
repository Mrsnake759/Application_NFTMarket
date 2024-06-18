//
//  NftsIDModel.swift
//  FakeNFT
//
//  Created by artem on 15.05.2024.
//

import Foundation

struct Likes: Codable {
    let likes: [String]
}

struct Orders: Codable {
    let nfts: [String]
}

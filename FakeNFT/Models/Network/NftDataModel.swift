//
//  NftDataModel.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation

struct NftDataModel: Decodable {
    var createdAt: String
    var name: String
    var images: [String]
    var rating: Int
    var description: String
    var price: Float
    var author: String
    var id: String

    init(nft: NftDataModel) {
        self.createdAt = nft.createdAt
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.description = nft.description
        self.price = nft.price
        self.author = nft.author
        self.id = nft.id
    }
}

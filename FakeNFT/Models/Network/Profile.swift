//
//  Profile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 01/05/24.
//

import Foundation

struct Profile: Decodable {
    let id: UUID
    let name: String
    let avatar: String
    let description: String
    let nfts: [String]
    let website: String
    let likes: [String]

    func toFormData() -> String {
            let encodedName = name
            let encodedAvatar = avatar.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let encodedDescription = description
            let encodedWebsite = website.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let encodedNfts = nfts.map { String($0) }.joined(separator: ",")
            var encodedLikes = likes.map { String($0) }.joined(separator: ",")
            if encodedLikes.isEmpty {
                encodedLikes = "null"
            }
            let encodedId = id

            return "&name=\(encodedName)&avatar=\(encodedAvatar)&description=\(encodedDescription)&website=\(encodedWebsite)&nfts=\(encodedNfts)&likes=\(encodedLikes)&id=\(encodedId)"
        }
}

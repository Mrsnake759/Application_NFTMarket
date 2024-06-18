//
//  NftByIdStorage.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation

protocol NftByIdStorageProtocol: AnyObject {
    var storage: [String: NftDataModel] {get}

    func saveNftById(_ nftById: NftDataModel)
    func getNftById(with id: String) -> NftDataModel?
    func removeNftById(with id: String)
    func removeAllNft()
}

final class NftByIdStorage: NftByIdStorageProtocol {

    internal var storage: [String: NftDataModel] = [:]

    func saveNftById(_ nftById: NftDataModel) {
        storage[nftById.id] = nftById
    }

    func getNftById(with id: String) -> NftDataModel? {
        storage[id]
    }

    func removeNftById(with id: String) {
        storage[id] = nil
    }

    func removeAllNft() {
        storage = [:]
    }
}

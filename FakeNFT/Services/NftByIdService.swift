//
//  NftByIdService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation
typealias NftByIdCompletion = (Result<NftDataModel, Error>) -> Void

protocol NftByIdServiceProtocol {
    func loadNft(id: String, completion: @escaping NftByIdCompletion)
}

final class NftByIdService: NftByIdServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: NftByIdStorageProtocol?

    init(networkClient: NetworkClient, storage: NftByIdStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftByIdCompletion) {
        if let nft = storage?.getNftById(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NftDataModel.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNftById(nft)
                completion(.success(nft))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}

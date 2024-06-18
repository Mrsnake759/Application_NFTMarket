//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderDataModel, Error>) -> Void
typealias RemoveOrderCompletion = (Result<[String], Error>) -> Void
typealias RemoveAllNftCompletion = (Result<Int, Error>) -> Void

protocol OrderServiceProtocol {
    var cartPresenter: CartPresenterProtocol? { get set}
    var nftsStorage: [NftDataModel] { get }

    func loadOrder(completion: @escaping OrderCompletion)
    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion)
    func removeAllNftFromStorage(completion: @escaping RemoveAllNftCompletion)
}

final class CartOrderService: OrderServiceProtocol {

    private let networkClient: NetworkClient
    private let orderStorage: OrderStorageProtocol
    private let nftByIdService: NftByIdServiceProtocol
    private var nftStorage: NftByIdStorageProtocol
    private var idsStorage: [String] = []
    var nftsStorage: [NftDataModel] = []

    var cartPresenter: CartPresenterProtocol?

    init(networkClient: NetworkClient, orderStorage: OrderStorageProtocol, nftByIdService: NftByIdServiceProtocol, nftStorage: NftByIdStorageProtocol) {
        self.networkClient = networkClient
        self.orderStorage = orderStorage
        self.nftByIdService = nftByIdService
        self.nftStorage = nftStorage
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: OrderDataModel.self) { [weak orderStorage] result in
            switch result {
            case .success(let order):
                orderStorage?.saveOrder(order)
                self.idsStorage.append(contentsOf: order.nfts)
                for nftId in order.nfts {
                    self.nftByIdService.loadNft(id: nftId) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case let .success(nft):
                            self.nftStorage.saveNftById(nft)
                            let contains = self.nftsStorage.contains {
                                model in
                                return model.id == nft.id
                            }
                            if !contains {
                                self.nftsStorage.append(nft)
                            }
                        case let .failure(error):
                            print(error)
                            completion(.failure(error))
                        }
                    }
                }
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion) {
        self.nftStorage.removeNftById(with: id)

        let request = ChangeOrderRequest(nfts: Array(self.nftStorage.storage.keys))
        networkClient.send(request: request, type: ChangedOrderDataModel.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.idsStorage.removeAll(where: { $0 == id })
                    self.nftsStorage.removeAll(where: { $0.id == id })
                    self.cartPresenter?.cartContent.removeAll(where: { $0.id == id })
                    self.nftStorage.removeNftById(with: id)

                    self.orderStorage.removeOrderById(with: id)
                    completion(.success(data.nfts))
                case let .failure(error):
                    completion(.failure(error))
                }
            }

        }
        return
    }

    func removeAllNftFromStorage(completion: @escaping RemoveAllNftCompletion) {
        let request = EmptyOrderRequest(nfts: [])

        networkClient.send(request: request, type: ChangedOrderDataModel.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.idsStorage.removeAll()
                    self.nftsStorage.removeAll()
                    self.cartPresenter?.cartContent = []
                    self.cartPresenter?.viewController?.updateCartTable()
                    self.cartPresenter?.viewController?.showEmptyCart()
                    self.nftStorage.removeAllNft()
                    self.orderStorage.removeOrder()
                    completion(.success(data.nfts.count))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
}

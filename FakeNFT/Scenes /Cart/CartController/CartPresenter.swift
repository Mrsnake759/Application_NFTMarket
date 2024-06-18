//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation
import UIKit

protocol CartPresenterProtocol {
    var cartContent: [NftDataModel] { get set}
    var viewController: CartViewControllerProtocol? { get set}

    func totalPrice() -> Float
    func count() -> Int
    func getOrder()
    func getNftById(id: String)
    func setOrder()
    func getModel(indexPath: IndexPath) -> NftDataModel
    func sortCart(filter: CartFilter.FilterBy)
}

final class CartPresenter: CartPresenterProtocol {

    internal weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderServiceProtocol?
    private var nftByIdService: NftByIdServiceProtocol?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"

    private var currentFilter: CartFilter.FilterBy {
        get {
            let id = userDefaults.integer(forKey: filterKey)
            return CartFilter.FilterBy(rawValue: id) ?? .id
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: filterKey)
        }
    }

    var cartContent: [NftDataModel] = []
    var orderIds: [String] = []

    var order: OrderDataModel?
    var nftById: NftDataModel?

    init(viewController: CartViewControllerProtocol, orderService: OrderServiceProtocol, nftByIdService: NftByIdServiceProtocol) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftByIdService = nftByIdService
        self.orderService?.cartPresenter = self
    }

    func totalPrice() -> Float {
        var price: Float = 0
        for nft in cartContent {
            price += nft.price
        }
        return price
    }

    func count() -> Int {
        let count: Int = cartContent.count
        print(count)
        return count
    }

    func getOrder() {
        viewController?.startLoadIndicator()
        orderService?.loadOrder { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let order):
                    self.order = order
                    self.cartContent = []
                    if !order.nfts.isEmpty {
                        order.nfts.forEach {
                            self.getNftById(id: $0)
                        }

                        self.viewController?.updateCartTable()
                    }

                    self.sortCart(filter: self.currentFilter)
                    self.viewController?.stopLoadIndicator()
                    self.viewController?.updateCartTable()
                    self.viewController?.showEmptyCart()
                case .failure(let error):
                    print(error)
                    self.viewController?.stopLoadIndicator()
                }
            }
        }
    }

    func getNftById(id: String) {
        viewController?.startLoadIndicator()
        nftByIdService?.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nftById = nft

                    let contains = self.cartContent.contains {
                        model in
                        return model.id == nft.id
                    }

                    if !contains {
                        self.cartContent.append(self.nftById!)
                    }

                    self.viewController?.showEmptyCart()
                    self.viewController?.stopLoadIndicator()
                    self.sortCart(filter: self.currentFilter)
                    self.viewController?.updateCartTable()
                case .failure(let error):
                    print(error)
                    self.viewController?.stopLoadIndicator()
                }
            }
        }
    }

    func setOrder() {
        guard let order = self.orderService?.nftsStorage else { return }
        self.cartContent = order

        viewController?.updateCartTable()
    }

    func getModel(indexPath: IndexPath) -> NftDataModel {
        let model = cartContent[indexPath.row]
        return model
    }

    func sortCart(filter: CartFilter.FilterBy) {
        currentFilter = filter
        cartContent = cartContent.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById)
        viewController?.updateCartTable()

    }

    @objc private func didCartSorted(_ notification: Notification) {
        guard let orderService = orderService  else { return }

        let orderUnsorted = orderService.nftsStorage.compactMap { NftDataModel(nft: $0) }
        cartContent = orderUnsorted.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById )
    }

}

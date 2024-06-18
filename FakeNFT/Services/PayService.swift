//
//  PayService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation

typealias CurrenciesCompletion = (Result<[CurrencyDataModel], Error>) -> Void
typealias PayCompletion = (Result<PayDataModel, Error>) -> Void

protocol PayServiceProtocol {
    func getCurrencies(completion: @escaping CurrenciesCompletion)
    func payOrder(currencyId: String, completion: @escaping PayCompletion)
}

final class PayService: PayServiceProtocol {

    let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()

        networkClient.send(request: request, type: [CurrencyDataModel].self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func payOrder(currencyId: String, completion: @escaping PayCompletion) {
        let request = PayRequest(currencyId: currencyId)

        networkClient.send(request: request, type: PayDataModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}

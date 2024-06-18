//
//  NftsViewProtocol.swift
//  FakeNFT
//
//  Created by Irina Deeva on 15/05/24.
//

import Foundation

protocol NftView: AnyObject, ErrorView, LoadingView {
    func fetchNfts(_ nft: [Nft])
}

//
//  CartFilter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 14.05.2024.
//

import Foundation

struct CartFilter {

    typealias FilterSorting = (NftDataModel, NftDataModel) -> Bool

    enum FilterBy: Int {
        case id
        case price
        case rating
        case title
    }

    static var filterById: FilterSorting = { first, second in
        first.id < second.id
    }

    static var filterByPrice: FilterSorting = { first, second in
        return first.price < second.price
    }

    static var filterByRating: FilterSorting = { first, second in
        return first.rating > second.rating
    }

    static var filterByTitle: FilterSorting = { first, second in
        return first.name < second.name
    }

    static let filter: [FilterBy: FilterSorting] = [.id: filterById, .price: filterByPrice, .rating: filterByRating, .title: filterByTitle]
}

//
//  ProfileStr.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: Profile)
    func getProfile() -> Profile?
}

final class ProfileStorageImpl: ProfileStorage {
    private var storage: Profile?

    func saveProfile(_ profile: Profile) {
        storage = profile
    }

    func getProfile() -> Profile? {
        return storage
    }
}

//
//  EditDetailAssemply.swift
//  FakeNFT
//
//  Created by Irina Deeva on 09/05/24.
//

import UIKit

public final class EditProfileDetailsAssembly {

    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func build() -> EditProfileDetailsViewController {
        let presenter = EditProfileDetailsPresenterImpl(
            service: profileService
        )

        let viewController = EditProfileDetailsViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}

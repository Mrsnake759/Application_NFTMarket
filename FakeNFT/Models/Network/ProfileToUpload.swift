//
//  UploadProfile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 15/05/24.
//

import Foundation

struct ProfileToUpload: Encodable {
    let name: String
    let description: String
    let website: String
    let avatar: String
}

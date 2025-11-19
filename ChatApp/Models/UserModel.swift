//
//  UserModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 21.10.2025.
//

struct User: Decodable {
    var uid: String
    let name: String
    let email : String
    let phone: String
    let profileImageUrl: String?
}

//
//  UserModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 21.10.2025.
//

struct User: Decodable {
    let name: String
    let uid: String
    let email : String
    let phone: String
    let profileImageUrl: String?
}

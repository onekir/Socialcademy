//
//  User.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 01.02.2024.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}

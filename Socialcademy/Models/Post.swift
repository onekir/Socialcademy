//
//  Post.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 04.05.2023.
//

import Foundation

struct Post: Identifiable, Equatable, Codable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var author: String
    var isFavorite: Bool = false
    var timestamp: Date = Date()

    
    func contains(_ str: String) -> Bool {
        let properties = [title, content, author].map { $0.lowercased() }
        let query = str.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
    
    init(title: String, content: String, author: String) {
        self.title = title
        self.content = content
        self.author = author
    }
    
    init() {
        self.title = ""
        self.content = ""
        self.author = ""
    }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        author: "Author"
    )
}

//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 06.05.2023.
//
protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchAllPosts() async throws -> [Post]
    func fetchFavoritePosts() async throws -> [Post]
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
}

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct PostsRepository: PostsRepositoryProtocol {
    
    let postsReference = Firestore.firestore().collection("posts_v2")
    
    // load posts to  db
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        do {
            try document.setData(from: post)
        } catch {
            fatalError("Error writing posts to Firestore: \(error)")
        }
    }
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
    
    // download posts from db
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
    }
    
    // download favorite posts from db
    func fetchFavoritePosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    // delete post from db
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    // favorite a post
    func favorite(_ post: Post) async throws {        
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
    }
      
    // unfavorite a post
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
 
    func create(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
    
    func unfavorite(_ post: Post) async throws {}
    
}
#endif

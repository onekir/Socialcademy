//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 30.01.2024.
//

import Foundation

@MainActor
class PostRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action
    private let favoriteAction: Action
    
    init(post: Post, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRowViewModel] Error: \(error)")
                self.error = error
            }
        }
    }
    
    func deletePost() {
        withErrorHandlingTask(perform: deleteAction)
    }
    
    func favoritePost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
}

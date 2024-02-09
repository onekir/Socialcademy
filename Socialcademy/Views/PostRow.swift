//
//  PostRow.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 04.05.2023.
//

import SwiftUI

struct PostRow: View {
    @StateObject var viewModel: PostRowViewModel
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.post.author)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(viewModel.post.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            
            Text(viewModel.post.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(viewModel.post.content)
            
            HStack {
                FavoriteButton(isFavorite: viewModel.post.isFavorite,
                               action: { viewModel.favoritePost() })
                
                Spacer()
                
                Button(role: .destructive, action: {
                    showConfirmationDialog = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
            }
            .buttonStyle(.borderless)
            .labelStyle(.iconOnly)
        }
        .padding(.vertical)
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: { viewModel.deletePost() })
        }
        .alert("Error", error: $viewModel.error)
    }
}

private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
        
        var body: some View {
            
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundColor(isFavorite ? .red : .gray)
            .animation(.default, value: isFavorite)
            
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
        }
    }
}

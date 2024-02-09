//
//  PostsList.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 04.05.2023.
//

import SwiftUI

struct PostsList: View {
    
    @StateObject var viewModel = PostsViewModel()

    
    @State private var searchText: String = ""
    @State private var showNewPostForm: Bool = false
    
    typealias DeleteAction = () async throws -> Void

    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(title: "Cannot Load Posts", message: error.localizedDescription, retryAction: { viewModel.fetchPosts() })
                case .empty:
                    EmptyListView(title: "No Posts", message: "There aren’t any posts yet.", retryAction: { })
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .sheet(isPresented: $showNewPostForm) {
            NewPostForm(createAction: viewModel.makeCreateAction())
        }
    }
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            PostsList(viewModel: viewModel)
        }
    }
}
#endif

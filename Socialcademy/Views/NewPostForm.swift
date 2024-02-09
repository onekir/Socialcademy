//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 06.05.2023.
//

import SwiftUI

struct NewPostForm: View {
    
    typealias CreateAction = (Post) async throws -> (Void)
    
    @State private var newPost = Post()
    
    let createAction: CreateAction
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var state: FormState = FormState.idle
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $newPost.title)
                    TextField("Author Name", text: $newPost.author)
                }
                Section("Content") {
                    TextEditor(text: $newPost.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: createPost) {
                    if state == .working
                    {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
                
            }
            .onSubmit(createPost)
            .navigationTitle("New Post")
        }
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}) {
            Text("Sorry, something went wrong.")
        }
    }
    
    private func createPost() {
        Task {
            state = .working
            do {
                try await createAction(newPost)
                dismiss()
            }
            catch{
                state = .error
                fatalError("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
}

private extension NewPostForm {
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
}

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(createAction: { _ in })
    }
}

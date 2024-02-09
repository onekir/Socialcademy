//
//  EmptyListView.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 11.05.2023.
//

import SwiftUI

struct EmptyListView: View {
    
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(message)
            if let retryAction = retryAction {
                Button(action: retryAction ) {
                    Text("Try again")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                }
                .padding(.top)
            }
        }
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding()
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var errorListView = EmptyListView(title: "Cannot Load Posts", message: "Some Error", retryAction: {  })
    static var empltyListView = EmptyListView(title: "No Posts", message: "There aren’t any posts yet.", retryAction: { })
    static var previews: some View {
        empltyListView
    }
}

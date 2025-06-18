//
//  IdeasListView.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import SwiftUI

/// Main screen displaying the list of video ideas.
/// Allows adding, deleting, and visualizing the status of each idea.
struct IdeasListView: View {
    @StateObject private var viewModel = VideoIdeasViewModel()
    @State private var showingNewIdeaSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.ideas) { idea in
                    NavigationLink(destination: IdeaDetailView(idea: idea)) {
                        VStack(alignment: .leading) {
                            Text(idea.title)
                                .font(.headline)
                            Text(idea.status.label)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteIdea)
            }
            .navigationTitle("ClipNest")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewIdeaSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewIdeaSheet) {
                NewIdeaView { newIdea in
                    viewModel.addIdea(newIdea)
                }
            }
        }
    }
}

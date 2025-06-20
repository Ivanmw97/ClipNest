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
            ZStack {
                Group {
                    if viewModel.ideas.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.ideas) { idea in
                                    NavigationLink(
                                        destination: IdeaDetailView(
                                            idea: idea,
                                            onSave: { updatedIdea in
                                                viewModel.updateIdea(updatedIdea)
                                            },
                                            onDelete: { ideaToDelete in
                                                viewModel.deleteIdea(ideaToDelete)
                                            }
                                        )
                                    ) {
                                        IdeaCardView(idea: idea)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 8)
                        }
                    }
                }

                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingNewIdeaSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("ClipNest")
            .sheet(isPresented: $showingNewIdeaSheet) {
                IdeaFormView { newIdea in
                    viewModel.addIdea(newIdea)
                }
            }
        }
    }

    /// Displayed when the idea list is empty.
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "lightbulb.min")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.accentColor.opacity(0.8))

            Text("No ideas yet")
                .font(.title2)
                .bold()

            Text("Tap the '+' button to create your first video idea.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

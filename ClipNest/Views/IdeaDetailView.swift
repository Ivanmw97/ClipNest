//
//  IdeaDetailView.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import SwiftUI

/// Displays full details of a selected video idea.
struct IdeaDetailView: View {
    let idea: VideoIdea

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(idea.title)
                    .font(.largeTitle)
                    .bold()

                Text("Status: \(idea.status.label)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                if !idea.description.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description:")
                            .font(.headline)
                        Text(idea.description)
                            .padding(.bottom, 8)
                    }
                }

                if !idea.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tags:")
                            .font(.headline)
                        Text(idea.tags.joined(separator: ", "))
                    }
                }

                Text("Created: \(idea.dateCreated.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Idea Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

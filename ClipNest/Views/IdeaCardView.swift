//
//  IdeaCardView.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import SwiftUI

/// Gradient card style for video ideas
struct IdeaCardView: View {
    let idea: VideoIdea

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                gradient: Gradient(colors: idea.status.gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(idea.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }

                Spacer()

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: idea.status.iconName)
                        Text(idea.status.label)
                    }
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Spacer()

                    Text(idea.dateCreated.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
}

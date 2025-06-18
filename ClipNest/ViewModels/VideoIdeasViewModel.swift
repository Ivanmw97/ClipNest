//
//  VideoIdeasViewModel.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import Foundation

/// ViewModel responsible for managing the list of video ideas.
/// Provides methods to add, remove, and update ideas, as well as filter them by status.
final class VideoIdeasViewModel: ObservableObject {
    @Published private(set) var ideas: [VideoIdea] = []

    init() {
        // Placeholder initial data (can be replaced with persistence logic)
        ideas = [
            VideoIdea(title: "Mi primer Short", tags: ["short", "funny"]),
            VideoIdea(title: "Top 5 errores en LoL", description: "Errores comunes que comete la mayoría", tags: ["league", "educativo"], status: .editing),
            VideoIdea(title: "Troleando a mi primo", status: .published)
        ]
    }

    func addIdea(_ idea: VideoIdea) {
        ideas.append(idea)
    }

    func deleteIdea(at offsets: IndexSet) {
        ideas.remove(atOffsets: offsets)
    }

    func updateIdea(_ idea: VideoIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
        }
    }

    func ideas(for status: VideoStatus) -> [VideoIdea] {
        ideas.filter { $0.status == status }
    }
}

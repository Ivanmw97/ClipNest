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
    @Published var ideas: [VideoIdea] = [] {
        didSet {
            saveIdeas()
        }
    }
    private let ideasKey = "saved_ideas"


    init() {
        loadIdeas()
        
        // Placeholder if empty
        if ideas.isEmpty {
            ideas = [
                VideoIdea(title: "Mi primer Short", tags: ["short", "funny"]),
                VideoIdea(title: "Top 5 errores en LoL", description: "Errores comunes que comete la mayoría", tags: ["league", "educativo"], status: .editing),
                VideoIdea(title: "Troleando a mi primo", status: .published)
            ]
        }
    }


    func addIdea(_ idea: VideoIdea) {
        ideas.append(idea)
    }

    func deleteIdea(at offsets: IndexSet) {
        ideas.remove(atOffsets: offsets)
    }
    
    func deleteIdea(_ idea: VideoIdea) {
        ideas.removeAll { $0.id == idea.id }
    }

    func updateIdea(_ idea: VideoIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
        }
    }

    func ideas(for status: VideoStatus) -> [VideoIdea] {
        ideas.filter { $0.status == status }
    }
    
    func loadIdeas() {
        guard let data = UserDefaults.standard.data(forKey: ideasKey),
              let decoded = try? JSONDecoder().decode([VideoIdea].self, from: data) else {
            return
        }
        ideas = decoded
    }

    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            UserDefaults.standard.set(encoded, forKey: ideasKey)
        }
    }

}

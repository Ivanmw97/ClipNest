//
//  VideoIdea.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import Foundation

/// Represents a video content idea with basic metadata and production status.
///
/// Used to track YouTube video ideas through different stages:
/// - Idea
/// - Recording
/// - Editing
/// - Published
///
/// Includes optional description, tags, and creation date for better organization and planning.


enum VideoStatus: String, CaseIterable, Identifiable, Codable {
    case idea = "Idea"
    case recording = "Recording"
    case editing = "Editing"
    case published = "Published"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .idea: return "🧠 Idea"
        case .recording: return "🎥 Recording"
        case .editing: return "✂️ Editing"
        case .published: return "✅ Published"
        }
    }
}

struct VideoIdea: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var tags: [String]
    var status: VideoStatus
    var dateCreated: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        tags: [String] = [],
        status: VideoStatus = .idea,
        dateCreated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.tags = tags
        self.status = status
        self.dateCreated = dateCreated
    }
}

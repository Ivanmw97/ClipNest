//
//  VideoIdea.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import Foundation
import SwiftUI

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
        case .idea: return "Idea"
        case .recording: return "Recording"
        case .editing: return "Editing"
        case .published: return "Published"
        }
    }
    
    /// Returns the corresponding SF Symbol name for UI icons.
    var iconName: String {
        switch self {
        case .idea: return "lightbulb"
        case .recording: return "video"
        case .editing: return "pencil"
        case .published: return "paperplane"
        }
    }
    
    var icon: Image {
        switch self {
        case .idea: return Image(systemName: "lightbulb")
        case .recording: return Image(systemName: "video.fill")
        case .editing: return Image(systemName: "pencil")
        case .published: return Image(systemName: "paperplane.fill")
        }
    }
    var gradient: [Color] {
        switch self {
        case .idea: return [Color.purple, Color.blue]
        case .recording: return [Color.orange, Color.pink]
        case .editing: return [Color.yellow, Color.green]
        case .published: return [Color.green, Color.teal]
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

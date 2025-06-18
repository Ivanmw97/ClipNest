//
//  NewIdeaView.swift
//  ClipNest
//
//  Created by Ivan Mendez Westlund on 18/6/25.
//

import SwiftUI

/// Form screen for creating a new video idea.
struct NewIdeaView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tagsText: String = ""
    @State private var status: VideoStatus = .idea

    var onSave: (VideoIdea) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter a title", text: $title)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }

                Section(header: Text("Tags (comma-separated)")) {
                    TextField("e.g. shorts,funny,gameplay", text: $tagsText)
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(VideoStatus.allCases) { s in
                            Text(s.label).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Idea")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let tags = tagsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }

                        let newIdea = VideoIdea(
                            title: title,
                            description: description,
                            tags: tags,
                            status: status
                        )
                        onSave(newIdea)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

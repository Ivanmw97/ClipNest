//
//  IdeaFormView.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import SwiftUI

/// Reusable form view for creating or editing a video idea.
struct IdeaFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var description: String
    @State private var tagsText: String
    @State private var status: VideoStatus

    var existingIdea: VideoIdea?
    var onSave: (VideoIdea) -> Void

    init(existingIdea: VideoIdea? = nil, onSave: @escaping (VideoIdea) -> Void) {
        self.existingIdea = existingIdea
        self.onSave = onSave

        _title = State(initialValue: existingIdea?.title ?? "")
        _description = State(initialValue: existingIdea?.description ?? "")
        _tagsText = State(initialValue: existingIdea?.tags.joined(separator: ", ") ?? "")
        _status = State(initialValue: existingIdea?.status ?? .idea)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with icon and status label only
                    HStack(alignment: .center, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: status.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                                )
                                .frame(width: 48, height: 48)
                            
                            status.icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(status.label)
                                .font(.title2)
                                .bold(true)
                                .foregroundColor(.secondary)
                                .frame(height: 20, alignment: .leading)
                        }
                        .frame(minWidth: 100, alignment: .leading)

                        Spacer()
                    }
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        TextField(title.isEmpty ? "⚠︎ Title is required" : "", text: $title)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .foregroundColor(.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(title.isEmpty ? Color.red : Color.clear, lineWidth: 1.5)
                            )

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                                .padding(10)
                                .background(.thinMaterial)
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags (comma-separated)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextField("e.g. shorts,funny,gameplay", text: $tagsText)
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(12)

                            // Live tag preview
                            let tags = tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                            if !tags.isEmpty {
                                Wrap(tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.accentColor.opacity(0.1))
                                        .foregroundColor(.accentColor)
                                        .cornerRadius(8)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            HStack {
                                ForEach(VideoStatus.allCases) { s in
                                    Text(s.label)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            LinearGradient(
                                                colors: s.gradient,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(s == status ? Color.white : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                status = s
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

                    Button(action: {
                        let tags = tagsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }

                        let newIdea = VideoIdea(
                            id: existingIdea?.id ?? UUID(),
                            title: title,
                            description: description,
                            tags: tags,
                            status: status,
                            dateCreated: existingIdea?.dateCreated ?? Date()
                        )
                        onSave(newIdea)
                        dismiss()
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.gray.opacity(0.4) : Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(existingIdea == nil ? "New Idea" : "Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Wrap layout for tag chips
struct Wrap<Data: RandomAccessCollection, Content: View, ID: Hashable>: View where Data.Element: Hashable {
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var content: (Data.Element) -> Content

    init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(data, id: id) { item in
                    content(item)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geometry.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == data.last {
                                width = 0
                            } else {
                                width -= d.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item == data.last {
                                height = 0
                            }
                            return result
                        }
                }
            }
        }
        .frame(height: 60) // ajustable si hay muchos tags
    }
}

//
//  IdeaDetailView.swift
//  ClipNest
//
//  Created by Ivan Mendez.
//

import SwiftUI

struct IdeaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    let idea: VideoIdea
    var onSave: (VideoIdea) -> Void
    var onDelete: (VideoIdea) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Encabezado con icono + título + estado
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: idea.status.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                            )
                            .frame(width: 48, height: 48)
                        
                        idea.status.icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(.title2)
                            .bold()
                        Text(idea.status.label)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                
                
                
                // Descripción
                if !idea.description.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(idea.description)
                    }
                }
                
                // Tags
                if !idea.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tags")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Wrap(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundColor(.accentColor)
                                .cornerRadius(12)
                        }
                    }
                }
                
                // Fecha
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("Created")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(idea.dateCreated.formatted(date: .long, time: .shortened))
                    }
                }
                
                // Botón de eliminar
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this idea", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 40)
                
            }
            .padding()
        }
        .navigationTitle("Idea Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            IdeaFormView(existingIdea: idea) { updatedIdea in
                onSave(updatedIdea)
            }
        }
        .alert("Delete this idea?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete(idea)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

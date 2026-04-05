//
//  RouteNameSheet.swift
//  RunnerWingmanKMP
//

import SwiftUI

struct RouteNameSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @FocusState private var isNameFocused: Bool

    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Nome da pista")
                    .font(.headline)

                TextField("Ex: Interlagos", text: $name)
                    .focused($isNameFocused)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.words)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { save() }

                Spacer()
            }
            .padding()
            .navigationTitle("Salvar rota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") { save() }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    isNameFocused = true
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSave(trimmed)
        dismiss()
    }
}

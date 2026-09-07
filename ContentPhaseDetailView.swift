import SwiftUI
import SwiftData

struct ContestPhaseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let phase: ContestPhase
    
    @State private var showingAddWork = false
    @State private var itemToDecide: ContestRepertoireItem?
    @State private var saveErrorMessage: String?
    
    private var sortedItems: [ContestRepertoireItem] {
        phase.repertoireItems
    }
    
    var body: some View {
        List {
            Section("Repertorio") {
                if let preparationSummary = phase.preparationSummary {
                    Label(
                        preparationSummary,
                        systemImage: "checkmark.circle"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(
                        "Preparación de la fase: \(preparationSummary)"
                    )
                }

                if sortedItems.isEmpty {
                    ContentUnavailableView(
                        "No hay obras",
                        systemImage: "music.note",
                        description: Text(
                            "Añade las obras que quieras interpretar en esta fase."
                        )
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(sortedItems) { item in
                        if let work = item.musicWork {
                            workRow(
                                work,
                                item: item
                            )
                        } else if let placeholder = item.placeholder,
                                  !placeholder.isEmpty {
                            placeholderRow(
                                placeholder,
                                item: item
                            )
                        }
                    }
                }
            }
            
            Section {
                Button {
                    showingAddWork = true
                } label: {
                    Label(
                        "Añadir obra",
                        systemImage: "plus"
                    )
                }
            }
        }
        .navigationTitle(phase.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddWork) {
            AddWorkToPhaseView(
                phase: phase
            )
        }
        .sheet(item: $itemToDecide) { item in
            SelectWorkForRepertoireItemView(
                phase: phase,
                item: item
            )
        }
        .alert(
            "No se pudo guardar el estado",
            isPresented: Binding(
                get: { saveErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        saveErrorMessage = nil
                    }
                }
            )
        ) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(saveErrorMessage ?? "Inténtalo de nuevo.")
        }
    }
    
    // MARK: - Work Row
    
    private func workRow(
        _ work: MusicWork,
        item: ContestRepertoireItem
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Text(work.title)
                .font(.headline)
            
            if !work.composer.isEmpty {
                Text(work.composer)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if !work.catalogue.isEmpty {
                Text(work.catalogue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            preparationMenu(for: item)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            removeButton(item)
        }
        .contextMenu {
            removeButton(item)
        }
        .accessibilityElement(children: .contain)
    }

    private func preparationMenu(
        for item: ContestRepertoireItem
    ) -> some View {
        Menu {
            ForEach(RepertoirePreparationStatus.allCases) { status in
                Button {
                    updatePreparationStatus(
                        status,
                        for: item
                    )
                } label: {
                    if item.preparationStatus == status {
                        Label(status.title, systemImage: "checkmark")
                    } else {
                        Text(status.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(item.preparationStatus.title)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .accessibilityHidden(true)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .accessibilityLabel("Estado de preparación")
        .accessibilityValue(item.preparationStatus.title)
        .accessibilityHint("Abre un menú para cambiar el estado")
    }

    private func updatePreparationStatus(
        _ status: RepertoirePreparationStatus,
        for item: ContestRepertoireItem
    ) {
        let previousStatus = item.preparationStatus
        guard status != previousStatus else {
            return
        }

        item.preparationStatus = status

        do {
            try modelContext.save()
        } catch {
            item.preparationStatus = previousStatus
            saveErrorMessage =
                "El cambio no se ha guardado. Inténtalo de nuevo."
        }
    }
    
    // MARK: - Placeholder Row
    
    private func placeholderRow(
        _ placeholder: String,
        item: ContestRepertoireItem
    ) -> some View {
        Button {
            itemToDecide = item
        } label: {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                HStack(spacing: 8) {
                    Image(
                        systemName: "questionmark.circle"
                    )
                    .foregroundStyle(.secondary)
                    
                    Text(placeholder)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                HStack {
                    Text("Por decidir")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("Elegir")
                        .font(.subheadline)
                        .foregroundStyle(.tint)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            removeButton(item)
        }
        .contextMenu {
            Button {
                itemToDecide = item
            } label: {
                Label(
                    "Elegir obra",
                    systemImage: "music.note"
                )
            }
            
            removeButton(item)
        }
    }
    
    // MARK: - Remove Button
    
    private func removeButton(
        _ item: ContestRepertoireItem
    ) -> some View {
        Button(role: .destructive) {
            remove(item)
        } label: {
            Label(
                "Quitar de la fase",
                systemImage: "minus.circle"
            )
        }
    }
    
    // MARK: - Remove
    
    private func remove(
        _ item: ContestRepertoireItem
    ) {
        if let index = phase.repertoireItems.firstIndex(
            where: { $0.id == item.id }
        ) {
            phase.repertoireItems.remove(
                at: index
            )
        }
        
        modelContext.delete(item)
    }
}

// MARK: - Select Work

private struct SelectWorkForRepertoireItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \MusicWork.composer)
    private var works: [MusicWork]
    
    let phase: ContestPhase
    let item: ContestRepertoireItem
    
    @State private var searchText = ""
    
    private var filteredWorks: [MusicWork] {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !query.isEmpty else {
            return works
        }
        
        return works.filter { work in
            work.title.localizedCaseInsensitiveContains(query)
            || work.composer.localizedCaseInsensitiveContains(query)
            || work.catalogue.localizedCaseInsensitiveContains(query)
            || work.subtitle.localizedCaseInsensitiveContains(query)
        }
    }
    
    private func isAlreadyInPhase(
        _ work: MusicWork
    ) -> Bool {
        for repertoireItem in phase.repertoireItems {
            if repertoireItem.id == item.id {
                continue
            }
            
            guard let existingWork = repertoireItem.musicWork else {
                continue
            }
            
            if existingWork.id == work.id {
                return true
            }
        }
        
        return false
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if works.isEmpty {
                    ContentUnavailableView(
                        "No hay obras",
                        systemImage: "music.note.list",
                        description: Text(
                            "Primero añade obras a tu repertorio."
                        )
                    )
                } else if filteredWorks.isEmpty {
                    ContentUnavailableView(
                        "No se encontraron obras",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "No hay obras que coincidan con la búsqueda."
                        )
                    )
                } else {
                    List(filteredWorks) { work in
                        let alreadyAdded = isAlreadyInPhase(work)
                        
                        Button {
                            select(work)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {
                                    Text(work.title)
                                        .font(.headline)
                                        .foregroundStyle(
                                            alreadyAdded
                                            ? .secondary
                                            : .primary
                                        )
                                    
                                    if !work.composer.isEmpty {
                                        Text(work.composer)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    if !work.catalogue.isEmpty {
                                        Text(work.catalogue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if alreadyAdded {
                                    Image(
                                        systemName: "checkmark"
                                    )
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel(
                                        "Ya añadida"
                                    )
                                }
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .disabled(alreadyAdded)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Elegir obra")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $searchText,
                prompt: "Buscar en mis obras"
            )
            .toolbar {
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func select(
        _ work: MusicWork
    ) {
        guard !isAlreadyInPhase(work) else {
            return
        }
        
        item.musicWork = work
        item.placeholder = nil
        
        dismiss()
    }
}

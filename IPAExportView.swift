import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let ipa = UTType(
        exportedAs: "com.apple.itunes.ipa",
        conformingTo: .zip
    )
}

struct IPAExportDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.ipa]
    }
    
    private let wrapper: FileWrapper
    
    init(url: URL) throws {
        wrapper = try FileWrapper(
            url: url,
            options: .immediate
        )
    }
    
    init(
        configuration: ReadConfiguration
    ) throws {
        wrapper = configuration.file
    }
    
    func fileWrapper(
        configuration: WriteConfiguration
    ) throws -> FileWrapper {
        wrapper
    }
}

struct IPAExportView: View {
    @State private var document: IPAExportDocument?
    @State private var showingExporter = false
    @State private var isPreparing = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section {
                Button {
                    prepareIPA()
                } label: {
                    Label(
                        isPreparing
                        ? "Preparando IPA..."
                        : "Exportar IPA",
                        systemImage: "square.and.arrow.up"
                    )
                }
                .disabled(isPreparing)
            } header: {
                Text("Exportación")
            } footer: {
                Text(
                    "Crea un archivo IPA a partir de la compilación de Contest Tracker que está ejecutando Swift Playground."
                )
            }
            
            Section("Instalación") {
                Text(
                    "El archivo exportado contiene la app actual dentro de Payload. Para instalarlo fuera de Swift Playground, iPadOS seguirá exigiendo una firma y un perfil de aprovisionamiento válidos."
                )
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Exportar IPA")
        .navigationBarTitleDisplayMode(.inline)
        .fileExporter(
            isPresented: $showingExporter,
            document: document,
            contentType: .ipa,
            defaultFilename: "Contest Tracker"
        ) { result in
            document = nil
            
            if case .failure(let error) = result {
                alertTitle = "No se pudo exportar"
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
        .alert(
            alertTitle,
            isPresented: $showingAlert
        ) {
            Button("Aceptar", role: .cancel) {
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func prepareIPA() {
        guard !isPreparing else {
            return
        }
        
        isPreparing = true
        
        Task {
            do {
                let url = try await Task.detached(
                    priority: .userInitiated
                ) {
                    try IPAExporter.export()
                }.value
                
                let preparedDocument = try IPAExportDocument(
                    url: url
                )
                
                try? FileManager.default.removeItem(
                    at: url
                )
                
                document = preparedDocument
                isPreparing = false
                showingExporter = true
            } catch {
                isPreparing = false
                alertTitle = "No se pudo crear el IPA"
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

struct AppSettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Desarrollo") {
                    NavigationLink {
                        IPAExportView()
                    } label: {
                        Label(
                            "Exportar IPA",
                            systemImage: "shippingbox"
                        )
                    }
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}

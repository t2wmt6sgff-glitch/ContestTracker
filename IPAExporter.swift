import Foundation

enum IPAExporter {
    enum ExportError: LocalizedError {
        case appBundleUnavailable
        case archiveNotProduced
        
        var errorDescription: String? {
            switch self {
            case .appBundleUnavailable:
                return "No se ha podido localizar el bundle .app que está ejecutando Swift Playground."
            case .archiveNotProduced:
                return "No se ha podido crear el archivo IPA."
            }
        }
    }
    
    static func export() throws -> URL {
        let fileManager = FileManager.default
        let appBundleURL = Bundle.main.bundleURL
        
        guard appBundleURL.pathExtension == "app" else {
            throw ExportError.appBundleUnavailable
        }
        
        let workingDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(
                "ContestTrackerExport-\(UUID().uuidString)",
                isDirectory: true
            )
        
        let payloadDirectory = workingDirectory
            .appendingPathComponent(
                "Payload",
                isDirectory: true
            )
        
        let outputURL = fileManager.temporaryDirectory
            .appendingPathComponent(
                "Contest-Tracker-\(UUID().uuidString).ipa"
            )
        
        defer {
            try? fileManager.removeItem(
                at: workingDirectory
            )
        }
        
        try fileManager.createDirectory(
            at: payloadDirectory,
            withIntermediateDirectories: true
        )
        
        let copiedAppURL = payloadDirectory
            .appendingPathComponent(
                appBundleURL.lastPathComponent,
                isDirectory: true
            )
        
        try fileManager.copyItem(
            at: appBundleURL,
            to: copiedAppURL
        )
        
        let coordinator = NSFileCoordinator()
        var coordinationError: NSError?
        var archiveError: Error?
        var archiveWasProduced = false
        
        coordinator.coordinate(
            readingItemAt: payloadDirectory,
            options: .forUploading,
            error: &coordinationError
        ) { archiveURL in
            do {
                var isDirectory: ObjCBool = false
                
                guard fileManager.fileExists(
                    atPath: archiveURL.path,
                    isDirectory: &isDirectory
                ), !isDirectory.boolValue else {
                    throw ExportError.archiveNotProduced
                }
                
                if fileManager.fileExists(
                    atPath: outputURL.path
                ) {
                    try fileManager.removeItem(
                        at: outputURL
                    )
                }
                
                try fileManager.copyItem(
                    at: archiveURL,
                    to: outputURL
                )
                
                archiveWasProduced = true
            } catch {
                archiveError = error
            }
        }
        
        if let coordinationError {
            throw coordinationError
        }
        
        if let archiveError {
            throw archiveError
        }
        
        guard archiveWasProduced else {
            throw ExportError.archiveNotProduced
        }
        
        return outputURL
    }
}

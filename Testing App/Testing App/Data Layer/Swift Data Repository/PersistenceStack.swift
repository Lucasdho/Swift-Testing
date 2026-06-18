//
//  PersistenceStack.swift
//  MixtapeApp
//
//  Created by Lucas Oliveira on 03/10/25.
//

import SwiftData
import Foundation

/// Persistence stack responsible for configuring and managing the model container and context.
@MainActor
public class PersistenceStack {

    /// The model container used to manage persistent data types.
    public let container: ModelContainer?

    /// The main context used for persistence operations.
    public let context: ModelContext?

    /// The array of persistent model types that will be managed.
    private let modelTypes: [any PersistentModel.Type]

    /// Initializes a new instance of `PersistenceStack`.
    ///
    /// - Parameters:
    ///   - modelTypes: Array of persistent model types to be managed.
    ///   - isMemoryOnly: Indicates whether the data should be stored in memory only.
    /// - Throws: An error if the initialization fails.
    public init(modelTypes: [any PersistentModel.Type], isMemoryOnly: Bool, storeName: String? = nil) throws {
        self.modelTypes = modelTypes
        let schema = Schema(modelTypes)
        let configuration: ModelConfiguration
        if let storeName, !isMemoryOnly,
           let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let url = base.appendingPathComponent("\(storeName).store")
            configuration = ModelConfiguration(schema: schema, url: url)
        } else {
            configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isMemoryOnly)
        }
        do {
            self.container = try ModelContainer(for: schema, configurations: [configuration])
            self.context = container?.mainContext
        } catch {
            throw DataLayerError.addFailed(error)
        }
    }
}

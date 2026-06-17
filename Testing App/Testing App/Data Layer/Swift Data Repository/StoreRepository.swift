//
//  StoreRepository.swift
//  MixtapeApp
//
//  Created by Lucas Oliveira on 03/10/25.
//

import SwiftData

/// Repository responsible for managing persistent models storage.
///
/// This class manages the persistence stack and provides methods to add, fetch,
/// save, and delete persistent models.
@MainActor
open class StoreRepository<Model: PersistentModel>: SwifDataRepository {

    /// Persistence stack used to store models.
    public let persistenceStack: PersistenceStack

    /// Initializes a new instance of `StoreRepository`.
    ///
    /// - Parameter stack: An instance of PersistenceStack.
    /// - Throws: An error if the persistence stack initialization fails.
    public init(stack: PersistenceStack) throws {
        self.persistenceStack = stack
    }

    // Explicit deinit suppresses an EarlyPerfInliner crash on generic classes during Release archiving.
    @_optimize(none)
    deinit {}
}

//
//  RepositoryProtocol.swift
//  MixtapeApp
//
//  Created by Lucas Oliveira on 03/10/25.
//

import SwiftData
/// Protocol defining basic operations for data repository.
@MainActor
public protocol SwifDataRepository {

    associatedtype Model: PersistentModel
    
    var persistenceStack: PersistenceStack { get }

    /// Adds a persistent model to the repository.
    func add(_ model: Model) throws

    /// Fetches all persistent models of a given type.
    func fetchAll() throws -> Set<Model>

    /// Fetches a persistent model by its identifier.
    func fetch(byID id: Model.ID) throws -> Model?

    /// Saves an array of models.
    func saveAll(_ models: [Model]) throws

    /// Deletes a specific persistent model.
    func delete(_ model: Model) throws

    /// Deletes all persistent models of a given type.
    func deleteAll(_ modelType: Model.Type) throws
}

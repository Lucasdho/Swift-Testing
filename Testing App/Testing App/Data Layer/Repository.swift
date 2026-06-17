//
//  Repository.swift
//  ladecasa
//
//  Created by Lucas Oliveira on 22/04/26.
//

import Foundation

/// Protocol defining basic operations for a framework-agnostic data repository.
protocol Repository {
    associatedtype Model: Hashable, Identifiable, Codable

    /// Adds a model to the repository.
    func add(_ model: Model) async throws

    /// Fetches all models.
    func fetchAll() async throws -> Set<Model>

    /// Fetches a model by its identifier.
    func fetch(byID id: Model.ID) async throws -> Model?
    
    /// Fetches models that match a predicate.
    func fetch(where predicate: @escaping @Sendable (Model) -> Bool) async throws -> Set<Model>

    /// Saves an array of models.
    func saveAll(_ models: [Model]) async throws

    /// Deletes a specific model.
    func delete(_ model: Model) async throws

    /// Deletes all models of a given type.
    func deleteAll(_ modelType: Model.Type) async throws
}

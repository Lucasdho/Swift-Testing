//
//  Repository+CRUD.swift
//  MixtapeApp
//
//  Created by Lucas Oliveira on 03/10/25.
//

import SwiftData

extension SwifDataRepository {
    public func add(_ model: Model) throws {
            guard let context = persistenceStack.context else {
                throw DataLayerError.invalidModelType
            }
            context.insert(model)
            do {
                try context.save()
            } catch {
                throw DataLayerError.addFailed(error)
            }
        }
        public func fetchAll() throws -> Set<Model> {
            guard let context = persistenceStack.context else {
                throw DataLayerError.invalidModelType
            }
            do {
                let results = try context.fetch(FetchDescriptor<Model>())
                return Set(results)
            } catch {
                throw DataLayerError.fetchFailed(error)
            }
        }
        public func fetch(byID id: Model.ID) throws -> Model? {
            let allModels = try fetchAll()
            return allModels.first { $0.id == id }
        }
        public func saveAll(_ models: [Model]) throws {
            for model in models {
                do {
                    try add(model)
                } catch {
                    throw DataLayerError.saveFailed(error)
                }
            }
        }
        public func delete(_ model: Model) throws {
            guard let context = persistenceStack.context else {
                throw DataLayerError.invalidModelType
            }
            context.delete(model)
            do {
                try context.save()
            } catch {
                throw DataLayerError.deleteFailed(error)
            }
        }
        public func deleteAll(_ modelType: Model.Type) throws {
            guard let context = persistenceStack.context else {
                throw DataLayerError.invalidModelType
            }
            do {
                let fetchDescriptor = FetchDescriptor<Model>()
                let results = try context.fetch(fetchDescriptor)
                for model in results {
                    context.delete(model)
                }
                try context.save()
            } catch {
                throw DataLayerError.deleteFailed(error)
            }
        }
}

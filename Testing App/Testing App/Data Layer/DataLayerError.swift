//
//  DataLayerError.swift
//  theordeal
//
//  Created by Lucas Oliveira on 03/11/25.
//

import Foundation

/// Errors specific to the data layer.
public enum DataLayerError: Error, LocalizedError {

    /// Failure to add the model.
    case addFailed(Error)

    /// Failure to fetch models.
    case fetchFailed(Error)

    /// Failure to delete the model.
    case deleteFailed(Error)

    /// Failure to save the context.
    case saveFailed(Error)

    /// Model not found.
    case modelNotFound

    /// Invalid model type.
    case invalidModelType
    
    /// Method not implemented yet.
    case methodNotImplemented

    /// Failure to encode the model to JSON.
    case encodingFailed(Error)

    /// Failure to decode the model from JSON.
    case decodingFailed(Error)

    /// Provides a localized description for the error.
    public var errorDescription: String? {
        switch self {
        case .addFailed(let error):
            return "Failed to add the model: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch models: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete the model: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "Failed to save the context: \(error.localizedDescription)"
        case .modelNotFound:
            return "Model not found."
        case .invalidModelType:
            return "Invalid model type."
        case .methodNotImplemented:
            return "Method not implemented yet."
        case .encodingFailed(let error):
            return "Failed to encode the model to JSON: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode the model from JSON: \(error.localizedDescription)"
        }
    }
}

//
//  ImageModel.swift
//  theordeal
//
//  Created by Lucas Oliveira on 03/12/25.
//

import Foundation
import SwiftData

@Model
public final class ImageModel {
    @Attribute(.unique) public var id: String
    @Attribute(.externalStorage) public var imageData: Data
    
    public var uploadedAt: Date
    
    public init(id: String, imageData: Data, uploadedAt: Date) {
        self.id = id
        self.imageData = imageData
        self.uploadedAt = uploadedAt
    }
}

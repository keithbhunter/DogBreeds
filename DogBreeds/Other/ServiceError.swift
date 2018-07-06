//
//  ServiceError.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct ServiceError: Codable, LocalizedError {
    let status: String
    let code: String
    let message: String
    var errorDescription: String? { return message }
}

//
//  ApplicationError.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct ApplicationError: LocalizedError {

    /// This string is what will show when calling `error.localizedDescription`.
    var errorDescription: String? { return description }
    private var description: String

    init(description: String) {
        self.description = description
    }

}

extension ApplicationError {

    static let unknown = ApplicationError(description: LocalizedString("Something went wrong. Please, try again."))
    static let decoding = ApplicationError(description: LocalizedString("Unable to decode data. Please, file a bug report."))
    static let malformedURL = ApplicationError(description: LocalizedString("Unexpected dog breed. Cannot fetch data for this breed."))

}

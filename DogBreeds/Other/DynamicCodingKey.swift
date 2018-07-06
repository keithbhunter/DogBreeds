//
//  DynamicCodingKey.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

/// When encoding/decoding, this struct allows you to dynamically read/create any coding key without knowing the values ahead of time.
struct DynamicCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }

    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

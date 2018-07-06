//
//  DogBreedList.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

/// Custom decodable class used to decode the breed list from a `DogService`.
struct DogBreedList: Decodable {

    private enum CodingKeys: String, CodingKey {
        case message
    }

    let breeds: [DogBreed]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let messageContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .message)

        breeds = try messageContainer.allKeys.map { key in
            let subBreeds = try messageContainer.decode([String].self, forKey: key).map { DogBreed.SubBreed(name: $0, parentBreedName: key.stringValue) }
            return DogBreed(name: key.stringValue, subBreeds: subBreeds)
        }
    }

}

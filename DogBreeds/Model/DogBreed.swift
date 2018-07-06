//
//  DogBreed.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

struct DogBreed: Decodable {

    struct SubBreed: Decodable {
        let name: String
        let parentBreedName: String
    }

    let name: String
    let subBreeds: [SubBreed]

}

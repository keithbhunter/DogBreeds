//
//  BreedListParsingTests.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import DogBreeds

class BreedListParsingTests: XCTestCase {
    
    func testBreedListParsing() {
        let url = Bundle(for: BreedListParsingTests.self).url(forResource: "DogBreedList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let breedList = try! JSONDecoder().decode(DogBreedList.self, from: data)

        XCTAssertEqual(breedList.breeds.count, 86)
    }
    
}

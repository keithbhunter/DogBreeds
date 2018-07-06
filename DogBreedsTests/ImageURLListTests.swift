//
//  ImageURLListTests.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import DogBreeds

class ImageURLListTests: XCTestCase {
    
    func testImageURLListParsing() {
        let url = Bundle(for: ImageURLListTests.self).url(forResource: "ImageURLList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let imageURLList = try! JSONDecoder().decode(ImageURLList.self, from: data)

        XCTAssertEqual(imageURLList.imageURLs.count, 150)
    }
    
}

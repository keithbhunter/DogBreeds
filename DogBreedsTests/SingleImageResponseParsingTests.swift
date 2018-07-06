//
//  SingleImageResponseParsingTests.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import DogBreeds

private let data = """
{
    "status": "success",
    "message": "https://images.dog.ceo/breeds/affenpinscher/n02110627_11858.jpg"
}
""".data(using: .utf8)!

class SingleImageResponseParsingTests: XCTestCase {

    func testSingleImageResponseParsing() {
        let response = try! JSONDecoder().decode(SingleImageResponse.self, from: data)
        XCTAssertEqual(response.imageURL, URL(string: "https://images.dog.ceo/breeds/affenpinscher/n02110627_11858.jpg")!)
    }

}

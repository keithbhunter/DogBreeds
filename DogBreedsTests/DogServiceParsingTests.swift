//
//  DogServiceParsingTests.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import DogBreeds

class DogServiceParsingTests: XCTestCase {
    
    func testSuccessfulResponse() {
        // Successful response meaning data and 200 status code.
        let url = Bundle(for: BreedListParsingTests.self).url(forResource: "DogBreedList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let result = DogNetworkService().checkForErrorsIn(data: data, response: response, error: nil)

        switch result {
        case .success(_): XCTAssert(true)
        case .failure(let error): XCTFail("\(error)")
        }
    }

    func testSuccessful200ButNoData() {
        let url = Bundle(for: BreedListParsingTests.self).url(forResource: "DogBreedList", withExtension: "json")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let result = DogNetworkService().checkForErrorsIn(data: nil, response: response, error: nil)

        switch result {
        case .success(_): XCTFail("We are always expecting data back from the service. If there is no data, it is not a successful service call.")
        case .failure(let error): XCTAssertEqual(error.localizedDescription, ApplicationError.unknown.localizedDescription)
        }
    }

    func testParsingOfErrorFromService() {
        let url = Bundle(for: BreedListParsingTests.self).url(forResource: "DogBreedList", withExtension: "json")!
        let serviceError = ServiceError(status: "error", code: "404", message: "Breed not found")
        let data = try! JSONEncoder().encode(serviceError)
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)

        let result = DogNetworkService().checkForErrorsIn(data: data, response: response, error: nil)

        switch result {
        case .success(_): XCTFail("We are always expecting data back from the service. If there is no data, it is not a successful service call.")
        case .failure(let error): XCTAssertEqual(error.localizedDescription, "Breed not found")
        }
    }
    
}

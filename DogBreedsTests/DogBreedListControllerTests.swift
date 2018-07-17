//
//  DogBreedListControllerTests.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/16/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import XCTest
@testable import DogBreeds

final class DogBreedListControllerTests: XCTestCase {

    let controller = DogBreedListController(service: MockDogService())

    func testThatControllerFetchesDogBreeds() {
        let exp = expectation(description: "testThatControllerFetchesDogBreeds")
        controller.fetchDogBreeds()

        // Dispatch to main so that the controller has time to load the data.
        DispatchQueue.main.async {
            XCTAssertTrue(!self.controller.breeds.isEmpty)
            exp.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(String(describing: error))
            }
        }
    }

    func testThatFetchingDogBreedsLoadsData() {
        let exp = expectation(description: "testThatFetchingDogBreedsLoadsData")
        controller.fetchDogBreeds()

        DispatchQueue.main.async {
            XCTAssertEqual(self.controller.tableView(UITableView(), numberOfRowsInSection: 0), 86, "There are 86 breeds in the mock JSON file")
            exp.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(String(describing: error))
            }
        }
    }

}

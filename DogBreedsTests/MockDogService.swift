//
//  MockDogService.swift
//  DogBreedsTests
//
//  Created by Keith Hunter on 7/16/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation
@testable import DogBreeds

final class MockDogService: DogService {

    func getListOfBreeds(_ completion: @escaping (Result<[DogBreed]>) -> Void) {
        let url = Bundle(for: BreedListParsingTests.self).url(forResource: "DogBreedList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let breedList = try! JSONDecoder().decode(DogBreedList.self, from: data)
        completion(.success(breedList.breeds))
    }

    func getImageURLs(of breed: DogBreed, completion: @escaping (Result<[URL]>) -> Void) {

    }

    func getRandomImageURL(of breed: DogBreed, completion: @escaping (Result<URL>) -> Void) {

    }

    func getImageURLs(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<[URL]>) -> Void) {

    }

    func getRandomImageURL(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<URL>) -> Void) {

    }


}

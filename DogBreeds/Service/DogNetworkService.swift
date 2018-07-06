//
//  DogNetworkService.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

final class DogNetworkService: DogService {

    private struct Endpoint {

        static let listAllBreeds = URL(string: "https://dog.ceo/api/breeds/list/all")!

        static func imagesByBreed(_ breed: DogBreed) -> URL? {
            return URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")
        }

        static func imagesBySubBreed(_ subBreed: DogBreed.SubBreed) -> URL? {
            return URL(string: "https://dog.ceo/api/breed/\(subBreed.parentBreedName)/\(subBreed.name)/images")
        }

    }

    func getListOfBreeds(_ completion: @escaping (Result<[DogBreed]>) -> Void) {
        URLSession.shared.dataTask(with: Endpoint.listAllBreeds) { data, response, error in
            switch self.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let breedList = try JSONDecoder().decode(DogBreedList.self, from: data)
                    completion(.success(breedList.breeds))
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }

            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

    func getImageURLs(of breed: DogBreed, completion: @escaping (Result<[String]>) -> Void) {

    }

    func getImageURLs(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<[String]>) -> Void) {

    }

}

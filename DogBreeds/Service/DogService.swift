//
//  DogService.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol DogService {

    func getListOfBreeds(_ completion: @escaping (Result<[DogBreed]>) -> Void)
    func getImageURLs(of breed: DogBreed, completion: @escaping (Result<[URL]>) -> Void)
    func getRandomImageURL(of breed: DogBreed, completion: @escaping (Result<URL>) -> Void)
    func getImageURLs(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<[URL]>) -> Void)
    func getRandomImageURL(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<URL>) -> Void)

}

extension DogService {

    /// Checks to see if there were any errors and ensures there is data in the response.
    func checkForErrorsIn(data: Data?, response: URLResponse?, error: Error?) -> Result<Data> {
        // Check for network errors, like no connectivity.
        if let err = error {
            return .failure(err)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(ApplicationError.unknown)
        }

        // Check for a successful response.
        if (200 ... 299).contains(httpResponse.statusCode), let data = data {
            return .success(data)
        }

        // Not a successful response, check for an error object from the API.
        if let data = data {
            do {
                let err = try JSONDecoder().decode(ServiceError.self, from: data)
                return .failure(err)
            } catch {
                print("Unable to decode error from response: \(String(describing: response))\n\(error)")
                return .failure(ApplicationError.decoding)
            }
        }

        // Unexpected response.
        return .failure(ApplicationError.unknown)
    }

}

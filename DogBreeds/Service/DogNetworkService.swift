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

        static func randomImageByBreed(_ breed: DogBreed) -> URL? {
            return URL(string: "https://dog.ceo/api/breed/\(breed.name)/images/random")
        }

        static func imagesBySubBreed(_ subBreed: DogBreed.SubBreed) -> URL? {
            return URL(string: "https://dog.ceo/api/breed/\(subBreed.parentBreedName)/\(subBreed.name)/images")
        }

        static func randomImageBySubBreed(_ subBreed: DogBreed.SubBreed) -> URL? {
            return URL(string: "https://dog.ceo/api/breed/\(subBreed.parentBreedName)/\(subBreed.name)/images/random")
        }

    }

    func getListOfBreeds(_ completion: @escaping (Result<[DogBreed]>) -> Void) {
        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: Endpoint.listAllBreeds) { data, response, error in
            NetworkActivityIndicator.shared.hideIndicator()

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

    func getImageURLs(of breed: DogBreed, completion: @escaping (Result<[URL]>) -> Void) {
        guard let url = Endpoint.imagesByBreed(breed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            NetworkActivityIndicator.shared.hideIndicator()

            switch self.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let imageList = try JSONDecoder().decode(ImageURLList.self, from: data)
                    completion(.success(imageList.imageURLs))
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }
            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

    func getRandomImageURL(of breed: DogBreed, completion: @escaping (Result<URL>) -> Void) {
        guard let url = Endpoint.randomImageByBreed(breed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { data, response, error in
            NetworkActivityIndicator.shared.hideIndicator()

            switch self.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(SingleImageResponse.self, from: data)
                    completion(.success(image.imageURL))
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }
            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

    func getImageURLs(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<[URL]>) -> Void) {
        guard let url = Endpoint.imagesBySubBreed(subBreed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { data, response, error in
            NetworkActivityIndicator.shared.hideIndicator()
            
            switch self.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let imageList = try JSONDecoder().decode(ImageURLList.self, from: data)
                    completion(.success(imageList.imageURLs))
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }
            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

    func getRandomImageURL(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<URL>) -> Void) {
        guard let url = Endpoint.randomImageBySubBreed(subBreed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { data, response, error in
            NetworkActivityIndicator.shared.hideIndicator()

            switch self.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(SingleImageResponse.self, from: data)
                    completion(.success(image.imageURL))
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }
            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

}

//
//  DogNetworkService.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class DogNetworkService: DogService {

    private struct Endpoint {

        static let listAllBreeds = URL(string: "https://dog.ceo/api/breeds/list/all")!

        static func imagesByBreed(_ breed: DogBreed) -> URL? {
            let endpoint = "https://dog.ceo/api/breed/\(breed.name)/images"
            guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encoded)
        }

        static func randomImageByBreed(_ breed: DogBreed) -> URL? {
            let endpoint = "https://dog.ceo/api/breed/\(breed.name)/images/random"
            guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encoded)
        }

        static func imagesBySubBreed(_ subBreed: DogBreed.SubBreed) -> URL? {
            let endpoint = "https://dog.ceo/api/breed/\(subBreed.parentBreedName)/\(subBreed.name)/images"
            guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encoded)
        }

        static func randomImageBySubBreed(_ subBreed: DogBreed.SubBreed) -> URL? {
            let endpoint = "https://dog.ceo/api/breed/\(subBreed.parentBreedName)/\(subBreed.name)/images/random"
            guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encoded)
        }

    }

    func getListOfBreeds(_ completion: @escaping (Result<[DogBreed]>) -> Void) {
        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: Endpoint.listAllBreeds) { [weak self] data, response, error in            
            guard let strongSelf = self else { return }
            NetworkActivityIndicator.shared.hideIndicator()

            switch strongSelf.checkForErrorsIn(data: data, response: response, error: error) {
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
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            NetworkActivityIndicator.shared.hideIndicator()

            switch strongSelf.checkForErrorsIn(data: data, response: response, error: error) {
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

    func getRandomImage(of breed: DogBreed, completion: @escaping (Result<(UIImage, Bool)>) -> Void) {
        guard let url = Endpoint.randomImageByBreed(breed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            NetworkActivityIndicator.shared.hideIndicator()

            switch strongSelf.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(SingleImageResponse.self, from: data)
                    strongSelf.getImage(from: image.imageURL, completion: completion)
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

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            NetworkActivityIndicator.shared.hideIndicator()
            
            switch strongSelf.checkForErrorsIn(data: data, response: response, error: error) {
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

    func getRandomImage(of subBreed: DogBreed.SubBreed, completion: @escaping (Result<(UIImage, Bool)>) -> Void) {
        guard let url = Endpoint.randomImageBySubBreed(subBreed) else {
            completion(.failure(ApplicationError.malformedURL))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            NetworkActivityIndicator.shared.hideIndicator()

            switch strongSelf.checkForErrorsIn(data: data, response: response, error: error) {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(SingleImageResponse.self, from: data)
                    strongSelf.getImage(from: image.imageURL, completion: completion)
                } catch {
                    print("Unable to decode data from response: \(String(describing: response))\n\(error)")
                    completion(.failure(ApplicationError.decoding))
                }
            case .failure(let error): completion(.failure(error))
            }
        }.resume()
    }

    func getImage(from url: URL, completion: @escaping (Result<(UIImage, Bool)>) -> Void) {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)), let image = UIImage(data: cachedResponse.data, scale: UIScreen.main.scale) {
            completion(.success((image, true)))
            return
        }

        NetworkActivityIndicator.shared.showIndicator()

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data, scale: UIScreen.main.scale) {
                completion(.success((image, false)))
            } else {
                completion(.success((#imageLiteral(resourceName: "no-dog"), false)))
            }
        }.resume()
    }

}

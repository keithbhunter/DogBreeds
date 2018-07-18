//
//  SingleImageResponse.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct SingleImageResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case message
    }

    let imageURL: URL

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageURLString = try container.decode(String.self, forKey: .message).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        if let string = imageURLString, let imageURL = URL(string: string) {
            self.imageURL = imageURL
        } else {
            throw DecodingError.dataCorruptedError(forKey: .message, in: container,
                                                   debugDescription: "Image URL string was not a valid URL: \(String(describing: imageURLString))")
        }
    }

}

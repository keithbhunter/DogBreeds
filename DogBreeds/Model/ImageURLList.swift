//
//  ImageURLList.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

struct ImageURLList: Decodable {

    private enum CodingKeys: String, CodingKey {
        case message
    }

    let imageURLs: [URL]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageURLs = try container.decode([String].self, forKey: .message).compactMap {
            guard let urlString = $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: urlString)
        }
    }

}

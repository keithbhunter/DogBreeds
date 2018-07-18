//
//  Array+DogBreeds.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/17/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import Foundation

extension Array {

    func divide(_ by: (Element) throws -> Bool) rethrows -> (quotient: [Element]?, remainder: [Element]?) {
        var quotient: [Element]?, remainder: [Element]?

        for element in self {
            if try by(element) {
                quotient == nil ? quotient = [element] : quotient?.append(element)
            } else {
                remainder == nil ? remainder = [element] : remainder?.append(element)
            }
        }

        return (quotient, remainder)
    }

}

extension Array where Element == DogBreed {

    func sorted() -> [DogBreed] {
        return sorted { $0.name < $1.name }
    }

    func splitAlphabetically() -> [[DogBreed]] {
        var copy = self
        var split = [[Element]]()
        let letters = String.sortedCapitalizedLetters

        for index in letters.startIndex ..< letters.endIndex {
            let result = copy.divide { String($0.name[$0.name.startIndex]).lowercased() == letters[index].lowercased() }

            if let quotient = result.quotient {
                split.append(quotient)
            }

            if let remainder = result.remainder {
                copy = remainder
            } else {
                break  // nothing left to sort out
            }
        }

        return split
    }

}

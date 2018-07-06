//
//  NetworkActivityIndicator.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class NetworkActivityIndicator {

    static let shared = NetworkActivityIndicator()

    private var numberOfActivities: UInt = 0 {
        didSet { UIApplication.shared.isNetworkActivityIndicatorVisible = numberOfActivities > 0 }
    }

    func showIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.numberOfActivities += 1
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, strongSelf.numberOfActivities > 0 else { return }
            strongSelf.numberOfActivities -= 1
        }
    }

}

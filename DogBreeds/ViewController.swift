//
//  ViewController.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let service: DogService


    // MARK: - Init

    init(service: DogService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        service.getListOfBreeds { result in
            switch result {
            case .success(let breeds):
                print(breeds)
            case .failure(let error):
                print(error)
            }
        }
    }

}


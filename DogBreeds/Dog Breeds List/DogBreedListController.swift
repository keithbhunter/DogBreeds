//
//  DogBreedListController.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class DogBreedListController: UIViewController {

    private(set) var breeds = [DogBreed]() {
        didSet { tableView.reloadData() }
    }

    private let service: DogService
    private var fetchDogBreedsTask = UIBackgroundTaskInvalid


    // MARK: - Init

    init(service: DogService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPallet.lightGrayBackground

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        fetchDogBreeds()
    }


    // MARK: - Network

    func fetchDogBreeds() {
        fetchDogBreedsTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let strongSelf = self else { return }
            UIApplication.shared.endBackgroundTask(strongSelf.fetchDogBreedsTask)
            strongSelf.fetchDogBreedsTask = UIBackgroundTaskInvalid
        }

        // TODO: Add loading animation

        service.getListOfBreeds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let breeds): self?.breeds = breeds.sorted { $0.name < $1.name }
                case .failure(let error):
                    // TODO: Add error view.
                    print(error)

                    guard let strongSelf = self else { return }
                    UIApplication.shared.endBackgroundTask(strongSelf.fetchDogBreedsTask)
                    strongSelf.fetchDogBreedsTask = UIBackgroundTaskInvalid
                }
            }
        }
    }


    // MARK: - Views

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = .clear
        table.estimatedRowHeight = 130

        table.dataSource = self
        table.register(DogBreedOverviewTableCell.self, forCellReuseIdentifier: String(describing: DogBreedOverviewTableCell.self))

        return table
    }()

}

extension DogBreedListController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DogBreedOverviewTableCell.self), for: indexPath) as! DogBreedOverviewTableCell
        cell.bind(breeds[indexPath.row])
        return cell
    }

}

//
//  DogBreedListController.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class DogBreedListController: UIViewController {

    private(set) var breeds = [[DogBreed]]() {
        didSet { tableView.reloadData() }
    }

    private let service: DogService
    private var fetchDogBreedsTask = UIBackgroundTaskInvalid
    private var imageCache = NSCache<NSIndexPath, UIImage>()
    private var imageDownloads = Set<IndexPath>()


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
        title = LocalizedString("Dog Breeds")
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        fetchDogBreeds()
    }


    // MARK: - Network

    @objc private func refresh() {
        imageCache.removeAllObjects()
        imageDownloads.removeAll()
        fetchDogBreeds()
    }

    func fetchDogBreeds() {
        fetchDogBreedsTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let strongSelf = self else { return }
            UIApplication.shared.endBackgroundTask(strongSelf.fetchDogBreedsTask)
            strongSelf.fetchDogBreedsTask = UIBackgroundTaskInvalid
        }

        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
            tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        }

        service.getListOfBreeds { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()

                switch result {
                case .success(let breeds): self?.breeds = breeds.sorted().splitAlphabetically()
                case .failure(let error):
                    print(error)

                    guard let strongSelf = self else { return }
                    UIApplication.shared.endBackgroundTask(strongSelf.fetchDogBreedsTask)
                    strongSelf.fetchDogBreedsTask = UIBackgroundTaskInvalid
                }
            }
        }
    }

    func fetchImage(forCell cell: DogBreedOverviewTableCell, at indexPath: IndexPath) {
        // Don't kick off multiple downloads for the same index path.
        guard !imageDownloads.contains(indexPath) else { return }
        imageDownloads.insert(indexPath)

        let breed = breeds[indexPath.section][indexPath.row]

        service.getRandomImage(of: breed) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image, let isFromCache):
                    self?.imageCache.setObject(image, forKey: indexPath as NSIndexPath)

                    if isFromCache {
                        cell.breedImageView.setImage(image)
                    } else if let cell = self?.tableView.cellForRow(at: indexPath) as? DogBreedOverviewTableCell {
                        cell.breedImageView.setImage(image, animated: true)
                    }
                case .failure:
                    let noImage = #imageLiteral(resourceName: "no-dog")
                    self?.imageCache.setObject(noImage, forKey: indexPath as NSIndexPath)

                    if let cell = self?.tableView.cellForRow(at: indexPath) as? DogBreedOverviewTableCell {
                        cell.breedImageView.setImage(noImage, animated: true)
                    }
                }

                self?.imageDownloads.remove(indexPath)
            }
        }
    }


    // MARK: - Views

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorColor = .clear
        table.estimatedRowHeight = 130

        table.dataSource = self
        table.delegate = self
        table.register(DogBreedOverviewTableCell.self, forCellReuseIdentifier: String(describing: DogBreedOverviewTableCell.self))

        table.addSubview(refreshControl)

        return table
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()

}

extension DogBreedListController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DogBreedOverviewTableCell.self), for: indexPath) as! DogBreedOverviewTableCell
        cell.bind(breeds[indexPath.section][indexPath.row])

        if let image = imageCache.object(forKey: indexPath as NSIndexPath) {
            cell.breedImageView.setImage(image, animated: false)
        } else {
            fetchImage(forCell: cell, at: indexPath)
        }

        return cell
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return String.sortedCapitalizedLetters
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return String.sortedCapitalizedLetters.index(of: title) ?? 0
    }

}

extension DogBreedListController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DogBreedOverviewTableCell else { return }

        cell.breedImageView.image = nil
        fetchImage(forCell: cell, at: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let breed = breeds[section].first else { return nil }
        return String(breed.name[breed.name.startIndex]).uppercased()
    }

}

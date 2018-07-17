//
//  DogBreedOverviewTableCell.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class DogBreedOverviewTableCell: UITableViewCell {

    struct LayoutAttributes {
        static let outerHorizontalMargin: CGFloat = 20
        static let outerVerticalMargin: CGFloat = 5
        static let innerMargin: CGFloat = 16
        static let imageSize = CGSize(width: 80, height: 80)
    }


    // MARK: - Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = ColorPallet.lightGrayBackground

        contentView.addSubview(containerView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(breedNameLabel)
        containerView.addSubview(subBreedNameLabel)

        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutAttributes.outerHorizontalMargin).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutAttributes.outerHorizontalMargin).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutAttributes.outerVerticalMargin).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutAttributes.outerVerticalMargin).isActive = true

        breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: LayoutAttributes.innerMargin).isActive = true
        breedImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LayoutAttributes.innerMargin).isActive = true
        breedImageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -LayoutAttributes.innerMargin).isActive = true
        breedImageView.widthAnchor.constraint(equalToConstant: LayoutAttributes.imageSize.width).isActive = true

        let heightConstraint = breedImageView.heightAnchor.constraint(equalToConstant: LayoutAttributes.imageSize.height)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
        heightConstraint.isActive = true

        setupLabels()
    }

    private func setupLabels() {
        // Use layout guides to center the labels in the view.
        let aboveLabelGuide = UILayoutGuide()
        let belowLabelGuide = UILayoutGuide()
        containerView.addLayoutGuide(aboveLabelGuide)
        containerView.addLayoutGuide(belowLabelGuide)
        aboveLabelGuide.heightAnchor.constraint(equalTo: belowLabelGuide.heightAnchor).isActive = true
        aboveLabelGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutAttributes.innerMargin).isActive = true
        aboveLabelGuide.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        belowLabelGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        breedNameLabel.leadingAnchor.constraint(equalTo: breedImageView.trailingAnchor, constant: LayoutAttributes.innerMargin).isActive = true
        breedNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -LayoutAttributes.innerMargin).isActive = true
        breedNameLabel.topAnchor.constraint(equalTo: aboveLabelGuide.bottomAnchor).isActive = true

        subBreedNameLabel.leadingAnchor.constraint(equalTo: breedImageView.trailingAnchor, constant: LayoutAttributes.innerMargin).isActive = true
        subBreedNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -LayoutAttributes.innerMargin).isActive = true
        subBreedNameLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: 8).isActive = true
        subBreedNameLabel.bottomAnchor.constraint(equalTo: belowLabelGuide.topAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        breedImageView.image = nil
        breedNameLabel.text = nil
        subBreedNameLabel.text = nil
    }


    // MARK: - Helpers

    func bind(_ breed: DogBreed) {
        breedNameLabel.text = breed.name

        let subBreedNames = breed.subBreeds.map { $0.name }
        if !subBreedNames.isEmpty {
            subBreedNameLabel.text = subBreedNames.joined(separator: ", ")
        }
    }


    // MARK: - Views

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

        return view
    }()

    let breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = ColorPallet.imageViewBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPallet.blackText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let subBreedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

}

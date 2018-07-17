//
//  UIImageView+DogBreeds.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/16/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImage(_ image: UIImage?, animated: Bool = false) {
        let duration = animated ? 0.3 : 0
        
        UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: nil)
    }

}

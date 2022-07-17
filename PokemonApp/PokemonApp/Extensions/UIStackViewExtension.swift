//
//  UIStackViewExtension.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 16/07/2022.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: Distribution){
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        
    }
}

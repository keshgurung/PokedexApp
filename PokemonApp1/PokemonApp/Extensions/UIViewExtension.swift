//
//  UIViewExtension.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 15/07/2022.
//


import UIKit


extension UIView {
    
    func bindToSuperView(insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        
        
        guard let superSafeArea = self.superview?.safeAreaLayoutGuide else {
            fatalError("Hey, you forgot to add the view to the view hiearchy. You done goofed up!!!")
        }
        
        self.topAnchor.constraint(equalTo: superSafeArea.topAnchor, constant: insets.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superSafeArea.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superSafeArea.trailingAnchor, constant: -insets.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superSafeArea.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    
}

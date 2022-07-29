//
//  UIViewControllerExtension.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 18/07/2022.
//

import UIKit

extension UIViewController {
    
    func presentNetworkErrorAlert(error: NetworkError) {
        let alert = UIAlertController(title: "Uh-Oh, Something went wrong", message: error.errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}


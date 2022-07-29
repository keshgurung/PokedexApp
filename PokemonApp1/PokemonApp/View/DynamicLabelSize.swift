//
//  DynamicLabelSize.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 22/07/2022.
//

import UIKit

class DynamiclabelSize {
    static func height(text: String? , width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        return currentHeight
    }
}

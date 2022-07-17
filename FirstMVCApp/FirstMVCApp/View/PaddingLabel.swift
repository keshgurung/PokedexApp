//
//  PaddingLabel.swift
//  FirstMVCApp
//
//  Created by iAskedYou2nd on 7/15/22.
//

import UIKit

class PaddingLabel: UILabel {

    var padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
//        self.layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var cSize = super.intrinsicContentSize
            cSize.height += self.padding * 2
            cSize.width += self.padding * 2
            return cSize
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

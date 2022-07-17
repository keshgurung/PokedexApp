//
//  PokemonViewCell.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 15/07/2022.
//

import UIKit

class PokemonViewCell: UITableViewCell {

    static let reuseID = "\(PokemonViewCell.self)"
    
    lazy var newImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemRed
        imageView.image = UIImage(named: "pp")
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "kesh"
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.backgroundColor = .systemPink
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "puff /puff"
//        label.setContentHuggingPriority(.defaultLow, for: .vertical)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.backgroundColor = .systemOrange
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        
        let hStack = UIStackView(axis: .horizontal, spacing: 8, distribution: .fill)
        let vStack = UIStackView(axis: .vertical, spacing: 8, distribution: .fill)
        
        vStack.addArrangedSubview(self.nameLabel)
        vStack.addArrangedSubview(self.typeLabel)
        
        hStack.addArrangedSubview(self.newImageView)
        hStack.addArrangedSubview(vStack)
        
        self.contentView.addSubview(hStack)
        
        hStack.bindToSuperView()
    }
    
    
//    func configure(page: ){
//        self.newImageView =
//        self.nameLabel.text =  page.name
//        self.typeLabel =
//    }

}

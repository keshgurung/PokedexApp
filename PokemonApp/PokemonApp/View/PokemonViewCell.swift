//
//  PokemonViewCell.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 15/07/2022.
//

import UIKit

class PokemonViewCell: UITableViewCell {
    

    static let reuseID = "\(PokemonViewCell.self)"
    
    var pokemonData : PokemonData?
    
    var allPokemon: [PokemonData] = []

     var pagesUrl: results?

    let network: NetworkManager = NetworkManager()
    
    var indexPath: Int = 0
    
    
    lazy var newImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
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
        label.backgroundColor = .systemPurple
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "puff /puff"
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

    private func requestData(){
        self.network.fetchPokeData(urlStr: pagesUrl?.url ?? "" ) { result in
                switch result {
                case .success(let data):
                   
                    self.allPokemon.append(data)
                    
                    var pokeTypes: [String] = []
                   
                    
                    for var i in 0..<data.types.count {
                        pokeTypes.append(data.types[i].type.name)
                        i += 1
                    }
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text =  " # \(self.indexPath + 1)  \(data.name)"
                        
                        self.typeLabel.text = pokeTypes.joined(separator: ",")
                        
                        
                        if let imageData = ImageCache.shared.getImageData(key: data.sprites.other.home.frontDefault) {
                            print("Image found in cache")
                            self.newImageView.image = UIImage(data: imageData)
                            return
                        }
                        
                        self.network.fetchImage(urlStr: data.sprites.other.home.frontDefault) { result in
                        switch result{
                        case .success(let imgData):
                            DispatchQueue.main.async {
                                print("img pld frm ntwrk \(data.name)")
                                ImageCache.shared.setImageData(data: imgData, key: data.sprites.other.home.frontDefault)
                                
//                                if self.pagesUrl?.url == (self. ?? "") {
                                    self.newImageView.image = UIImage(data: imgData)
//                                }
                                  

                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func configure(pagesUrl: results, indexPath: Int, network: NetworkManager ){
        
        self.pagesUrl =  pagesUrl
        self.indexPath = indexPath
        requestData()
      
    }
    override func prepareForReuse() {
        self.nameLabel.text = " name title"
        self.typeLabel.text = " type title"
        self.newImageView.image = UIImage(named: "pp")
    }
}

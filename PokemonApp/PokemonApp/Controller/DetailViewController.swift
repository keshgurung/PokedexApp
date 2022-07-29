//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 18/07/2022.
//

import UIKit

class DetailViewController: UIViewController {

    
    lazy var topImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray
        return imageView
    }()

    lazy var topNameLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Name"
        label.backgroundColor = .cyan
        return label
    }()
    
    lazy var topTypeLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Type"
        label.backgroundColor = .cyan
        return label
    }()
    
    lazy var topAbilityLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Ability"
        label.backgroundColor = .cyan
        return label
    }()
    
    
    lazy var topMovesLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Moves"
        label.backgroundColor = .cyan
        return label
    }()
    
    
    let network: NetworkManager = NetworkManager()
    
    var pokemonData : PokemonData?
    var allPokemon: PokemonData?
    
    var pagesUrl: results?
    
    init(pagesUrl: results){
        self.pagesUrl = pagesUrl
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func requestData(){
        
        self.network.fetchPokeData(urlStr: pagesUrl?.url ?? "" ) { result in
                switch result {
                case .success(let data):
                    
                    var pokeTypes: [String] = []
                    var abilities: [String] = []
                    var moves:[String] = []
                    for var i in 0..<data.types.count {
                        pokeTypes.append(data.types[i].type.name)
                        i += 1
                    }
                    for var i in 0..<data.abilities.count {
                        abilities.append(data.abilities[i].ability.name)
                        i += 1
                    }
                    for var i in 0..<data.moves.count {
                        moves.append(data.moves[i].move.name)
                        i += 1
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.topTypeLabel.text = "Type: \(pokeTypes.joined(separator: ","))"
                        self.topNameLabel.text = "Name: \(data.name)"
                        self.topAbilityLabel.text = "Ability: \(abilities.joined(separator: ","))"
//                        self.topMovesLabel.text = "Moves: \(moves.joined(separator: ","))"
                        
                        if let imageData = ImageCache.shared.getImageData(key: data.sprites.other.home.frontDefault) {
                            print("Image found in cache")
                            self.topImageView.image = UIImage(data: imageData)
                            return
                        }
                        
                        self.network.fetchImage(urlStr: data.sprites.other.home.frontDefault) { result in
                        switch result{
                        case .success(let imgData):
                            DispatchQueue.main.async {
                                print("img pld frm ntwrk")
                                ImageCache.shared.setImageData(data: imgData, key: data.sprites.other.home.frontDefault)
                                
//                                if self.pagesUrl?.url == (self. ?? "") {
//                                    self.newImageView.image = UIImage(data: imgData)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemPurple
        
        self.setUpUI()
        requestData()
        
//        self.topNameLabel.text = "Name: \(self.pagesUrl?.url ?? "")"
//        self.topImageView.image = UIImage(named: self.allPokemon?.sprites.other.home.frontShiny ?? "pp")
//        self.topTypeLabel.text = "Type: \(self.allPokemon?.types[0].type.name ?? "")"
//        self.topMovesLabel.text = "Moves: \(self.allPokemon?.moves[0].move.name ?? "")"
//        self.topAbilityLabel.text = "Ability: \(self.allPokemon?.abilities[0].ability.name ?? "")"
//
        // Do any additional setup after loading the view.
    }
    
    private func setUpUI(){
        self.view.addSubview(self.topImageView)
        self.view.addSubview(self.topNameLabel)
        self.view.addSubview(self.topTypeLabel)
        self.view.addSubview(self.topAbilityLabel)
        self.view.addSubview(self.topMovesLabel)
        
        self.topImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.topImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.topImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.topImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -300).isActive = true

        self.topNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.topNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.topNameLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -270).isActive = true
//        self.topNameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.topTypeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.topTypeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.topTypeLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -240).isActive = true
//        self.topTypeLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.topAbilityLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.topAbilityLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.topAbilityLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -210).isActive = true
//        self.topAbilityLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.topMovesLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.topMovesLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.topMovesLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -180).isActive = true

    }
    
}

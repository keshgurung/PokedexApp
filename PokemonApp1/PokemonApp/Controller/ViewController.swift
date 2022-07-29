//
//  ViewController.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 14/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var pagesUrl : [results] = []
//    it gives 15 data at once.. so to call 150 we make final count to (151-15 = 136)
    let totalData: Int = 136
    var currentData: Int = 0
    
    var pokemon: PokemonData?
    
    let network: NetworkManager = NetworkManager()
 
    
    var pokemonData : PokemonData?
    
    var allPokemon: [PokemonData] = []
    
//    var Pokemon: [Int : PokemonData]?

    
    lazy var pokeTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.register(PokemonViewCell.self, forCellReuseIdentifier: PokemonViewCell.reuseID)
        return table
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.requestPage()
        
        // Do any additional setup after loading the view.
    }

    private func setUpUI(){
        self.view.backgroundColor = .clear
        self.title = "Pokeee-mon"
        self.view.addSubview(self.pokeTable)
        self.pokeTable.bindToSuperView()
       
    }
    
    private func requestPage(){
        self.network.fetchPage(urlStr : "https://pokeapi.co/api/v2/pokemon?offset=\(self.currentData)&limit=30"){ result in
            switch result {
            case .success(let page):
               
                self.currentData += 30
                
                self.pagesUrl.append(contentsOf: page.results)
                
                DispatchQueue.main.async {
                    self.pokeTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
      
    }
    
 
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pagesUrl.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonViewCell.reuseID, for: indexPath) as? PokemonViewCell else {
          
            return UITableViewCell()
        }
        
        self.network.fetchPokeData( urlStr: self.pagesUrl[indexPath.row].url) { result in
                        switch result {
                        case .success(let data):
//                            group.enter()
                            DispatchQueue.main.async {
                                self.allPokemon.append(data)
                                print(self.allPokemon)
                            }
                    
                            DispatchQueue.main.async {
                                
                            var pokeTypes: [String] = []
        
                            for var i in 0..<data.types.count {
                                pokeTypes.append(data.types[i].type.name)
                                i += 1
                              }
                                cell.nameLabel.text =  " # \(indexPath.row + 1)  \(data.name)"
        
                                cell.typeLabel.text = pokeTypes.joined(separator: ",")
        
        
                                if let imageData = ImageCache.shared.getImageData(key: data.sprites.other.home.frontDefault) {
                                    print("Image found in cache")
                                    cell.newImageView.image = UIImage(data: imageData)
                                    return
                                }
        
                                self.network.fetchImage(urlStr: data.sprites.other.home.frontDefault) { result in
                                switch result{
                                case .success(let imgData):
                                    DispatchQueue.main.async {
                                        print("img pld frm ntwrk \(data.name)")
                                        ImageCache.shared.setImageData(data: imgData, key: data.sprites.other.home.frontDefault)
        
//                                        if indexPath.row == data.id {
                                            cell.newImageView.image = UIImage(data: imgData)
//                                        }
        
        
                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
        
                            }
//                            })
                        case .failure(let error):
                            print(error)
                           
                        }
                    
                }
        return cell
    }
    
}


extension ViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = DetailViewController(allPokemon: allPokemon[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
}

extension ViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.pagesUrl.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        
        if self.currentData < self.totalData{
            self.requestPage()
        }
       
    }
}


                                                                    

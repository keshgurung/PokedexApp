//
//  ViewController.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 14/07/2022.
//

import UIKit



class ViewController: UIViewController {

    var pagesUrl : [results] = []
    var pokeData: [PokemonData] = []
    let urlData: [String] = []
    
    lazy var pokeTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.delegate = self
        table.register(PokemonViewCell.self, forCellReuseIdentifier: PokemonViewCell.reuseID)
        return table
    }()
    
    
    let network: NetworkManager = NetworkManager()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        self.network.fetchPage(urlStr : "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10"){ result in
            
            switch result {
            case .success(let page):
//                self.pagesUrl = page.results
                self.pagesUrl.append(contentsOf: page.results)
              
                DispatchQueue.main.async {
                    self.pokeTable.reloadData()
                }
               
                
//                let group = DispatchGroup(
               
            case .failure(let error):
                print(error)
            }
        }
        
    
        
        
        // Do any additional setup after loading the view.
    }


    private func setUpUI(){
        self.view.backgroundColor = .clear
        self.title = "Pokeee-mon"
        self.view.addSubview(self.pokeTable)
        self.pokeTable.bindToSuperView()
    }

}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.pagesUrl.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonViewCell.reuseID, for: indexPath) as? PokemonViewCell else {
            return UITableViewCell()
        }
        
        var kk = self.pagesUrl[indexPath.row].url
        print(kk)
              
//        cell.configure(page: self.pagesUrl[indexPath.row])
        self.network.fetchPokeData(urlStr: self.pagesUrl[indexPath.row].url ) { result in
            switch result {
            case .success(let data):
                print(data)
                print("yoo")
            case .failure(let error):
                print(error)

            }
        }
return cell
        
    }


   
   
}

extension ViewController: UITableViewDelegate {

}
//https://pokeapi.co/api/v2/pokemon/1/

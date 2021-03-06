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
    var indexKeying: [IndexPath: String] = [:]
    var visibleIndexPath = Set<IndexPath>()
    let network: NetworkManager = NetworkManager()
 
    
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
                print(page)
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
        print(self.pagesUrl.count)
        return self.pagesUrl.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonViewCell.reuseID, for: indexPath) as? PokemonViewCell else {
          
            return UITableViewCell()
        }
//        cell.delegate = self
        cell.configure(pagesUrl: self.pagesUrl[indexPath.row], indexPath: indexPath.row, network: self.network)
 
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.visibleIndexPath.remove(indexPath)
    }
    
    
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = DetailViewController(pagesUrl: pagesUrl[indexPath.row])
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


                                                                    

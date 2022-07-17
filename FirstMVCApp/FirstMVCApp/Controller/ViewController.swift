//
//  ViewController.swift
//  FirstMVCApp
//
//  Created by iAskedYou2nd on 7/13/22.
//

import UIKit

/*
 TODO:
    0: Add padding label - Sort of
    1: More robust error handling - Done
    2: pagination for infinite scrolling - Done
    3: Fix visual constraint issue of showing full description - Done
    4: Image Caching - Done
    5: Showcase code refactor with Dispatch Group
    6: Fix issue with images appearing in wrong cell - Done
    7: Not going to do, but limiting the number of requests allowed at any time and canceling requests
    8: Potentially play with velocity of scroll for requests
 */



class ViewController: UIViewController {

    lazy var movieTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .systemCyan
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseId)
        return table
    }()
    
    let network: NetworkManager = NetworkManager()
    var movies: [Movie] = []
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.requestPage()
    }
    
    private func setUpUI() {
        self.view.addSubview(self.movieTable)
        self.movieTable.bindToSuperView()
    }
    
    private func requestPage() {
        
        self.network.fetchPage(urlStr: "https://api.themoviedb.org/3/movie/popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&language=en-US&page=\(self.currentPage + 1)") { result in
            
            switch result {
            case .success(let page):
                self.currentPage += 1
                self.movies.append(contentsOf: page.results)
                DispatchQueue.main.async {
                    self.movieTable.reloadData()
                }
            case .failure(let error):
                print(error)
                
                self.presentNetworkErrorAlert(error: error)
            }
            
        }
    }
        


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseId, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(movie: self.movies[indexPath.row], network: self.network)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if indexPath.row == self.movies.count - 5 {
//            self.requestPage()
//        }
//
//    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.movies.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.requestPage()
    }
    
}


extension ViewController: MovieCellErrorDelegate {
    
    func initiateErrorMsg(err: NetworkError) {
        self.presentNetworkErrorAlert(error: err)
    }
    
}

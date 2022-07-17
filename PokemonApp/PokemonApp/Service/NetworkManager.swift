//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 14/07/2022.
//

import Foundation

class NetworkManager {
    
    let session : URLSession
    
    
    init(session: URLSession = URLSession.shared){
        self.session = session
    }
}

extension NetworkManager {
    
    func fetchPage (urlStr: String, completion: @escaping (Result<PokemonPage, Error>) -> Void) {

        guard let url = URL(string: urlStr) else {
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            
            do {
                let page = try JSONDecoder().decode(PokemonPage.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    
    func fetchPokeData(urlStr: String, completion: @escaping (Result<PokemonData, Error>) -> Void ){
        guard let url = URL(string: urlStr) else {
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            
            do {
                let data = try JSONDecoder().decode(PokemonData.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
}

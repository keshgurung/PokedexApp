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
    
    func fetchPage(urlStr: String, completion: @escaping (Result<PokemonPage, Error>) -> Void) {

        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            if let hResponse = response as? HTTPURLResponse,!(200..<300).contains(hResponse.statusCode){
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            guard let data = data else {
                    completion(.failure(NetworkError.dataFailure))
                return
            }
            do {
                let page = try JSONDecoder().decode(PokemonPage.self, from: data)
                completion(.success(page))
            } catch {
                    completion(.failure(NetworkError.decodeError(error)))
            }
        }.resume()
        
    }
    
    
    func fetchPokeData(urlStr: String, completion: @escaping (Result<PokemonData, NetworkError>) -> Void ){
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            if let hResponse = response as? HTTPURLResponse,!(200..<300).contains(hResponse.statusCode){
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            guard let data = data else {
                    completion(.failure(NetworkError.dataFailure))
                return
            }
            do {
                let data = try JSONDecoder().decode(PokemonData.self, from: data)
                completion(.success(data))
            } catch {
                    completion(.failure(NetworkError.decodeError(error)))
            }
        }.resume()
        
    }
    
    func fetchImage(urlStr: String, completion: @escaping (Result<Data, NetworkError>) -> Void ){
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
           
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            if let hResponse = response as? HTTPURLResponse,!(200..<300).contains(hResponse.statusCode){
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataFailure))
                return
            }
            
            completion(.success(data))
        }.resume()
        
    }
    
}

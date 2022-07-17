//
//  NetworkManager.swift
//  FirstMVCApp
//
//  Created by iAskedYou2nd on 7/14/22.
//

import Foundation


class NetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager {
    
    func fetchPage(urlStr: String, completion: @escaping (Result<MoviePage, NetworkError>) -> Void) {

        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            if let hResponse = response as? HTTPURLResponse, !(200..<300).contains(hResponse.statusCode) {
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataFailure))
                return
            }
            
            
            do {
                let page = try JSONDecoder().decode(MoviePage.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(NetworkError.decodeError(error)))
            }

        }.resume()

    }
    
    
    func fetchImageData(urlStr: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            if let hResponse = response as? HTTPURLResponse, !(200..<300).contains(hResponse.statusCode) {
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


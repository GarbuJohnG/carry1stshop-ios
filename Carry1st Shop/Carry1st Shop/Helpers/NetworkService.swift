//
//  NetworkService.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import Foundation

class NetworkService {
    
    /// Network Error Types
    enum NetworkError: Error {
        case invalidURL
        case dataDecodeError
        case noData
    }
    
    
    /// This allows for the fetching of data of Generic type T using GET from the specified endpoint with a fixed baseURL defined in Constants
    /// - Parameters:
    ///   - endpoint: Endpoint with which we rely on to get specified data
    ///   - responseType: Response we are expecting from the server
    ///   - completion: Provides completion data or error in case the function fails
    func fetchData<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: Constants.URLs.baseUrl + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(NetworkError.dataDecodeError))
            }
            
        }.resume()
        
    }
    
}

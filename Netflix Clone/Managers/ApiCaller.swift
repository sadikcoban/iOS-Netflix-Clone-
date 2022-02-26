//
//  ApiCaller.swift
//  Netflix Clone
//
//  Created by Sadık Çoban on 26.02.2022.
//

import Foundation

struct Constants {
    static let API_KEY = "8191457f50fa244b2e8c4128c81b39cb"
    static let baseUrl = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class ApiCaller {
    static let shared = ApiCaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(result.results))
                
            } catch  {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
}

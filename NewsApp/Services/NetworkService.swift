//
//  NetworkService.swift
//  NewsApp
//
//  Created by Jaya on 27/01/25.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let apiKey = "bea560f27d124679bd9a25696668709a"
    
    func fetchNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(.success(response.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

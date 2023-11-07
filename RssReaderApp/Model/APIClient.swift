//
//  APIClient.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import Foundation

protocol APIClientProtocol {
    func fetch(url: String, completion: @escaping ((Result<RssFeedData, APIError>) -> Void))
}

class APIClient: APIClientProtocol {
    func fetch(url: String, completion: @escaping ((Result<RssFeedData, APIError>) -> Void)) {
        guard let url: URL =  URL(string:"https://api.rss2json.com/v1/api.json?rss_url=\(url)") else {
            return completion(.failure(.invalidURL))
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else { throw APIError.networkError }
                guard let rssFeedData = try? JSONDecoder().decode(RssFeedData.self, from: data) else {
                    throw APIError.emptyValue
                }
                DispatchQueue.main.async {
                    completion(.success(rssFeedData))
                }
            } catch {
                if error as? APIError == APIError.networkError {
                    completion(.failure(.networkError))
                } else if error as? APIError == APIError.emptyValue {
                    completion(.failure(.emptyValue))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

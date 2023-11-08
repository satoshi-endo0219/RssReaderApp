//
//  APIClient.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import Foundation

protocol APIClientProtocol {
    /// RSSFeedDataを取得する
    /// - Parameters:
    ///   - rssFeedUrl: dataを取得するURL
    ///   - completion: 成功、失敗を返す
    func fetchRSSFeedData(rssFeedUrl: String?, completion: @escaping ((Result<RssFeedData, APIError>) -> Void))
}

class APIClient: APIClientProtocol {   
    var isLoading = false

    func fetchRSSFeedData(rssFeedUrl: String?, completion: @escaping ((Result<RssFeedData, APIError>) -> Void)) {
        if isLoading {
            return
        }
        guard let rssFeedUrl = rssFeedUrl, let url: URL =  URL(string:"https://api.rss2json.com/v1/api.json?rss_url=\(rssFeedUrl)") else {
            return completion(.failure(.invalidURL))
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = `self` else { return }
            isLoading = true
            do {
                guard let data = data else { throw APIError.networkError }
                guard let rssFeedData = try? JSONDecoder().decode(RssFeedData.self, from: data) else {
                    throw APIError.emptyValue
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(.success(rssFeedData))
                }
            } catch {
                self.isLoading = false
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

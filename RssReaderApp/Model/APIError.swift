//
//  APIError.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
    case emptyValue
    case unknown

    var title: String {
        switch self {
            case .invalidURL:
                return "無効なURLのエラー"
            case .networkError:
                return "ネットワークエラー"
            case .emptyValue:
                return "値が空で取得されたエラー"
            default:
                return "不明なエラー"
        }
    }
}

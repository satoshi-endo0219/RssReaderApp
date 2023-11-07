//
//  RssFeedData.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import Foundation

struct RssFeedData: Codable {
    let feed: FeedData
    let items: [NewsItem]
}

struct FeedData: Codable {
    let url: String
    let title: String
    let link: URL
    let description: String
}

struct NewsItem: Codable {
    let title: String
    let link: URL
    let guid: String
    let pubDate: String
}

//
//  RssFeedData.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import Foundation

struct RssFeedData: Codable {
    /// feedのデータ
    let feed: FeedData
    /// 記事一覧のデータ
    var items: [NewsItem]

    init(feed: FeedData, items: [NewsItem]) {
        self.feed = feed
        self.items = items
    }
}

struct FeedData: Codable {
    /// feedDataを取得したURL
    let url: String
    /// Feedのタイトル
    let title: String
    /// linkのURL
    let link: String
    /// Feedの説明
    let description: String

    init(url: String, title: String, link: String, description: String) {
        self.url = url
        self.title = title
        self.link = link
        self.description = description
    }
}

struct NewsItem: Codable, Hashable {
    /// Newsタイトル
    let title: String
    /// NewsのLink
    let link: String
    /// guid
    let guid: String
    /// pubDate
    let pubDate: String

    init(title: String, link: String, guid: String, pubDate: String) {
        self.title = title
        self.link = link
        self.guid = guid
        self.pubDate = pubDate
    }
}

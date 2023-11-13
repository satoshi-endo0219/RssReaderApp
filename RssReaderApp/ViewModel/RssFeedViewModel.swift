//
//  RssFeedViewModel.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import SwiftUI

// Viewの値を宣言的に変更させるために、ObservableObjectに準拠させる
final class RssFeedViewModel: ObservableObject {
    // @PublishedでViewで表示される値を宣言的に変更できる
    @Published var rssFeedData: RssFeedData = .init(feed: .init(url: "", title: "", link: "", description: ""), items: [])
    private let apiClient: APIClient = APIClient()

    func loadData(url: String?) {
        apiClient.fetchRSSFeedData(rssFeedUrl: url,
                                   completion: { [weak self] result in
            guard let self = `self` else {
                return
            }
            switch result {
                case .success(let rssFeedData):
                    self.rssFeedData = rssFeedData
                case .failure(let error):
                    print(error.title)
            }
        })
    }

    func sort(sortItem: String) {
        if sortItem == Const.sortItemsNew {
            rssFeedData.items.sort(by: {
                DateUtils.dateFromString(dateString: $0.pubDate).compare(DateUtils.dateFromString(dateString: $1.pubDate)) == .orderedDescending
            })
        } else if sortItem == Const.sortItemsOld {
            rssFeedData.items.sort(by: {
                DateUtils.dateFromString(dateString: $0.pubDate).compare(DateUtils.dateFromString(dateString: $1.pubDate)) == .orderedAscending
            })
        }
    }
}

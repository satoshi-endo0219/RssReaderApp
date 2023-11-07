//
//  NewsListView.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/07.
//

import SwiftUI

struct NewsListView: View {
    var url: String?
    @ObservedObject private var viewModel = RssFeedViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.rssFeedData?.items ?? [], id: \.self) { newsItem in
                    Text("・\(newsItem.title)")
                }
            }
        }
        .navigationBarTitle(viewModel.rssFeedData?.feed.title ?? "",
                            displayMode: .inline)
        .onAppear(perform: {
            self.viewModel.loadData(url: url)
        })
    }

    init(url: String?) {
        self.url = url
    }
}

struct NewsListView_preview: PreviewProvider {
    static var previews: some View {
        NewsListView(url: Const.topPicsXML)
    }
}

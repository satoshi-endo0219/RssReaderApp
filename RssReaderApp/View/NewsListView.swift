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
    @ObservedObject private var selectFeedDataViewModel = SelectFeedDataViewModel()
    @Environment(\.managedObjectContext)private var context

    static let rowHeight: CGFloat = 50
    static let rowMargin: CGFloat = 0.5
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(viewModel.rssFeedData?.feed.title ?? "" )) {
                    ForEach(viewModel.rssFeedData?.items ?? [], id: \.self) { newsItem in
                        NavigationLink(
                            destination: {
                                DetailNewsView(url: newsItem.link)
                            },
                            label: {
                                Text("・\(newsItem.title)")
                            }
                        )
//                        Text("・\(newsItem.title)")
                    }
                }
                NavigationLink {
                    SelectRssFeedView()
                } label: {
                    Text(Const.toSelectRssFeedView)
                }
            }
            .navigationTitle("記事一覧")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            self.viewModel.loadData(url: url)
            selectFeedDataViewModel.writeData(context: context)
        }
    }

    init(url: String?) {
        self.url = url
        self.selectFeedDataViewModel.url = url ?? ""
    }
}

struct NewsListView_preview: PreviewProvider {
    static var previews: some View {
        NewsListView(url: Const.topPicsXML)
    }
}

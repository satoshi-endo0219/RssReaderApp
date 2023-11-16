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
    @ObservedObject private var favoriteFeedDataViewModel = FavoriteFeedDataViewModel()
    @ObservedObject private var alreadyReadNewsDataViewModel = AlreadyReadNewsDataViewModel()
    @Environment(\.managedObjectContext)private var context
    
    let sortItems: [String] = [Const.sortItemsNew, Const.sortItemsOld, Const.nonAlreadyRead, Const.favorite]
    @State private var selectedIndex = 0
    @State private var favoriteFeedDatas: [FavoriteFeedData] = []
    @State private var isAlreadyRead: Bool = true
    @State private var nonAlreadyReadNewsItems: [NewsItem] = []
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("\(Const.sortOrder):")
                        .font(.system(size: 16))
                    Picker(Const.sortOrder, selection: $selectedIndex, content: {
                        ForEach(0 ..< sortItems.count, id: \.self) { num in
                            Text(self.sortItems[num])
                        }
                    })
                }
                .onChange(of: selectedIndex) { num in
                    if sortItems[num] == Const.favorite {
                        favoriteFeedDatas = favoriteFeedDataViewModel.getAllData(context: context)
                    } else {
                        viewModel.sort(sortItem: sortItems[num])
                    }
                }
                List {
                    if sortItems[selectedIndex] == Const.favorite {
                        Section(header: Text(Const.favorite)) {
                            ForEach($favoriteFeedDatas, id: \.self, editActions: .delete) { $favoriteItem in
                                NavigationLink(
                                    destination: {
                                        DetailNewsView(newsItem: toNewsItem(favoriteItem: $favoriteItem.wrappedValue))
                                    },
                                    label: {
                                        HStack {
                                            if $isAlreadyRead.wrappedValue {
                                                Text(getAlreadyReadString(newsItem: toNewsItem(favoriteItem: $favoriteItem.wrappedValue)))
                                            } else {
                                                Text(getAlreadyReadString(newsItem: toNewsItem(favoriteItem: $favoriteItem.wrappedValue)))
                                            }
                                            Text("・\($favoriteItem.title.wrappedValue ?? "")")
                                                .truncationMode(.tail)
                                                .lineLimit(1)
                                        }
                                    }
                                )
                            }.onDelete(perform: { indexSet in
                                for index in indexSet{
                                    let favoriteItem = favoriteFeedDatas[index]
                                    favoriteFeedDataViewModel.newsItem = toNewsItem(favoriteItem: favoriteItem)
                                    favoriteFeedDataViewModel.deleteData(context: context)
                                }
                                rowRemove(offsets: indexSet)
                            })
                        }
                    } else {
                        Section(header: Text(viewModel.rssFeedData.feed.title)) {
                            ForEach(viewModel.rssFeedData.items, id: \.self) { newsItem in
                                NavigationLink(
                                    destination: {
                                        DetailNewsView(newsItem: newsItem)
                                    },
                                    label: {
                                        HStack {
                                            if $isAlreadyRead.wrappedValue {
                                                Text(getAlreadyReadString(newsItem: newsItem))
                                            } else {
                                                Text(getAlreadyReadString(newsItem: newsItem))
                                            }
                                            Text("・\(newsItem.title)")
                                                .truncationMode(.tail)
                                                .lineLimit(1)
                                        }
                                    }
                                )
                                .swipeActions(edge: .trailing) {
                                    NewsListSwipeActionButton(newsItem: newsItem)
                                }
                            }
                        }
                        Section {
                            NavigationLink {
                                SelectRssFeedView()
                            } label: {
                                Text(Const.toSelectRssFeedView)
                            }
                        }
                    }
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
    /// 行削除処理
    func rowRemove(offsets: IndexSet) {
        favoriteFeedDatas.remove(atOffsets: offsets)
    }

    func getAlreadyReadString(newsItem: NewsItem) -> String {
        let alreadyNewsDatas = alreadyReadNewsDataViewModel.getAllData(context: context)
        let isALreadyNewsItem = alreadyNewsDatas.contains(where: { $0.guid == newsItem.guid })
        if isALreadyNewsItem {
            return Const.alreadyRead
        }
        return Const.nonAlreadyRead
    }

    func toNewsItem(favoriteItem: FavoriteFeedData) -> NewsItem {
        return NewsItem(title: favoriteItem.title ?? "", link: favoriteItem.url ?? "", guid: favoriteItem.guid ?? "", pubDate: favoriteItem.pubDate ?? "")
    }

    func getNonAlreadyReadNewsDatas() {
        let alreadyNewsItems = alreadyReadNewsDataViewModel.getAllData(context: context)
        let newsItems = viewModel.rssFeedData.items
        for newsItem in newsItems {
            for alreadyNewsItem in alreadyNewsItems {
                if newsItem.guid != alreadyNewsItem.guid {
                    nonAlreadyReadNewsItems.append(newsItem)
                }
            }
        }
    }
}

struct NewsListView_preview: PreviewProvider {
    static var previews: some View {
        NewsListView(url: Const.topPicsXML)
    }
}

struct NewsListSwipeActionButton: View {
    @ObservedObject private var favoriteFeedDataViewModel = FavoriteFeedDataViewModel()
    @State var newsItem: NewsItem
    @State private var favoriteFeedDatas: [FavoriteFeedData] = []
    @State private var isFavorite = false
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        Button(action:{
            self.isFavorite = getIsFavorite(newsItem: newsItem)
            self.isFavorite.toggle()
            favoriteFeedDataViewModel.newsItem = newsItem
            favoriteFeedDataViewModel.writeData(context: context)
        }) {
            if getIsFavorite(newsItem: newsItem) {
                Text(Const.cancellRegisteFavorite)
            } else {
                Text(Const.registerFavorite)
            }
        }
    }

    init (newsItem: NewsItem) {
        self.newsItem = newsItem
    }

    func getIsFavorite(newsItem: NewsItem) -> Bool {
        DispatchQueue.main.async {
            self.favoriteFeedDatas = favoriteFeedDataViewModel.getAllData(context: context)
            print("お気に入り登録済みの記事：\(self.favoriteFeedDatas)")
        }
        for favoriteItem in favoriteFeedDatas {
            if favoriteItem.guid == newsItem.guid {
                return true
            }
        }
        return false
    }
}

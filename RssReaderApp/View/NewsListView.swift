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
    @ObservedObject private var afterReadingNewsDataViewModel = AfterReadingNewsDataViewModel()
    @Environment(\.managedObjectContext)private var context
    
    let sortItems: [String] = [Const.sortItemsNew, Const.sortItemsOld, Const.nonAlreadyReadList, Const.afterReadingList, Const.favorite]
    @State private var selectedIndex = 0
    @State private var favoriteFeedDatas: [FavoriteFeedData] = []
    @State private var isAlreadyRead: Bool = false
    @State private var nonAlreadyReadNewsItems: [NewsItem] = []
    @State private var afterReadingDatas: [AfterReadingNewsData] = []
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
                    } else if sortItems[num] == Const.nonAlreadyReadList {
                        nonAlreadyReadNewsItems = getNonAlreadyReadNewsDatas()
                    } else if sortItems[num] == Const.afterReadingList {
                        afterReadingDatas = afterReadingNewsDataViewModel.getAllData(context: context)
                    }else {
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
                                    }()
                                        .onDisappear {
                                            isAlreadyRead = true
                                        }
                                    ,
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
                    } else if sortItems[selectedIndex] == Const.nonAlreadyReadList {
                        Section(header: Text(viewModel.rssFeedData.feed.title)) {
                            ForEach($nonAlreadyReadNewsItems, id: \.self) { $newsItem in
                                NavigationLink(
                                    destination: {
                                        DetailNewsView(newsItem: $newsItem.wrappedValue)
                                    }()
                                        .onDisappear{
                                            nonAlreadyReadNewsItems = getNonAlreadyReadNewsDatas()
                                        }
                                    ,
                                    label: {
                                        Text("・\($newsItem.title.wrappedValue)")
                                            .truncationMode(.tail)
                                            .lineLimit(1)
                                    }
                                )
                                .swipeActions(edge: .trailing) {
                                    NewsListSwipeActionButton(newsItem: $newsItem.wrappedValue)
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
                    } else if sortItems[selectedIndex] == Const.afterReadingList {
                        Section(header: Text(Const.afterReadingList)) {
                            ForEach($afterReadingDatas, id: \.self) { $afterReadingData in
                                NavigationLink(
                                    destination: {
                                        DetailNewsView(newsItem: toNewsItem(afterReadingItem: $afterReadingData.wrappedValue))
                                    }()
                                        .onDisappear {
                                            isAlreadyRead = true
                                        }
                                    ,
                                    label: {
                                        HStack {
                                            if $isAlreadyRead.wrappedValue {
                                                Text(getAlreadyReadString(newsItem: toNewsItem(afterReadingItem: $afterReadingData.wrappedValue)))
                                            } else {
                                                Text(getAlreadyReadString(newsItem: toNewsItem(afterReadingItem: $afterReadingData.wrappedValue)))
                                            }
                                            Text("・\($afterReadingData.title.wrappedValue ?? "")")
                                                .truncationMode(.tail)
                                                .lineLimit(1)
                                        }
                                    }
                                )
                            }
                            .onDelete(perform: { indexSet in
                                for index in indexSet{
                                    let afterReadingItem = afterReadingDatas[index]
                                    afterReadingNewsDataViewModel.newsItem = toNewsItem(afterReadingItem: afterReadingItem)
                                    afterReadingNewsDataViewModel.deleteData(context: context)
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
                                    }()
                                        .onDisappear {
                                            isAlreadyRead = true
                                        }
                                    ,
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
        switch sortItems[selectedIndex] {
            case Const.favorite:
                self.favoriteFeedDatas.remove(atOffsets: offsets)
            case Const.afterReadingList:
                self.afterReadingDatas.remove(atOffsets: offsets)
            default:
                break
        }
    }

    func getAlreadyReadString(newsItem: NewsItem) -> String {
        let alreadyNewsDatas = alreadyReadNewsDataViewModel.getAllData(context: context)
        let isALreadyNewsItem = alreadyNewsDatas.contains(where: { $0.guid == newsItem.guid })
        if isALreadyNewsItem {
            return Const.alreadyRead
        }
        return Const.nonAlreadyRead
    }

    func toNewsItem(favoriteItem: FavoriteFeedData? = nil, afterReadingItem: AfterReadingNewsData? = nil ) -> NewsItem {
        var newsItem = NewsItem(title: "", link: "", guid: "", pubDate: "")
        if let favoriteItem = favoriteItem {
            newsItem = NewsItem(title: favoriteItem.title ?? "", link: favoriteItem.url ?? "", guid: favoriteItem.guid ?? "", pubDate: favoriteItem.pubDate ?? "")
        }
        if let  afterReadingItem = afterReadingItem {
            newsItem = NewsItem(title: afterReadingItem.title ?? "", link: afterReadingItem.url ?? "", guid: afterReadingItem.guid ?? "", pubDate: afterReadingItem.pubDate ?? "")
        }
        return newsItem
    }

    func getNonAlreadyReadNewsDatas() -> [NewsItem] {
        var newsItems = viewModel.rssFeedData.items
        let alreadyNewsItems = alreadyReadNewsDataViewModel.getAllData(context: context)
        for alreadyNewsItem in alreadyNewsItems {
            newsItems.removeAll(where: { $0.guid == alreadyNewsItem.guid})
        }
        print("未読一覧：\(newsItems)")
        return newsItems
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
    @State private var isFavorite = false
    @ObservedObject private var afterReadingNewsDataViewModel = AfterReadingNewsDataViewModel()
    @State private var isAfterReading = false
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        HStack {
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
            Button(action: {
                self.isAfterReading = getIsAfterReading(newsItem: newsItem)
                self.isAfterReading.toggle()
                afterReadingNewsDataViewModel.newsItem = newsItem
                afterReadingNewsDataViewModel.writeData(context: context)
            }) {
                if getIsAfterReading(newsItem: newsItem) {
                    Text(Const.cancelRegisterAfterReading)
                } else {
                    Text(Const.registerAfterReading)
                }
            }
        }
    }

    init (newsItem: NewsItem) {
        self.newsItem = newsItem
    }

    func getIsFavorite(newsItem: NewsItem) -> Bool {
        for favoriteItem in favoriteFeedDataViewModel.getAllData(context: context) {
            if favoriteItem.guid == newsItem.guid {
                return true
            }
        }
        return false
    }

    func getIsAfterReading(newsItem: NewsItem) -> Bool {
        for afterReadingData in afterReadingNewsDataViewModel.getAllData(context: context) {
            if afterReadingData.guid == newsItem.guid {
                return true
            }
        }
        return false
    }
}

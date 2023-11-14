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
    @Environment(\.managedObjectContext)private var context
    
    let sortItems: [String] = [Const.sortItemsNew, Const.sortItemsOld, Const.favorite]
    @State private var selectedIndex = 0
    @State private var favoriteFeedDatas: [FavoriteFeedData] = []

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("並び替え:")
                        .font(.system(size: 16))
                    Picker("並び替え", selection: $selectedIndex, content: {
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
                                        DetailNewsView(url: favoriteItem.url)
                                    }, label: {
                                        Text("・\(favoriteItem.title ?? "")")
                                    }
                                )
                            }.onDelete(perform: { indexSet in
                                for index in indexSet{
                                    let deleteGuid = favoriteFeedDatas[index].guid
                                    favoriteFeedDataViewModel.deleteGuid = deleteGuid ?? ""
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
                                        DetailNewsView(url: newsItem.link)
                                    },
                                    label: {
                                        Text("・\(newsItem.title)")
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
            if self.isFavorite {
                print("お気に入り登録：\(newsItem)")
                favoriteFeedDataViewModel.favoriteItem = newsItem
                favoriteFeedDataViewModel.writeData(context: context)
            } else {
                print("お気に入り登録解除：\(newsItem)")
                favoriteFeedDataViewModel.deleteGuid = newsItem.guid
                favoriteFeedDataViewModel.deleteData(context: context)
            }
        }) {
            if getIsFavorite(newsItem: newsItem) {
                Text(Const.registerdFavorite)
            } else {
                Text(Const.nonRegisterdFavorite)
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

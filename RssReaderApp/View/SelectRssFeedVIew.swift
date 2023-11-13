//
//  SelectRssFeedView.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/02.
//

import SwiftUI

struct Feed: Hashable {
    var name : String
    var url: String
}

struct SelectRssFeedView: View {
    @State private var feedlist = [
        Feed(name: Const.topPics, url: Const.topPicsXML),
        Feed(name: Const.domestic, url: Const.businessXML),
        Feed(name: Const.world, url: Const.worldXML),
        Feed(name: Const.business, url: Const.businessXML),
        Feed(name: Const.entertainment, url: Const.entertainmentXML),
        Feed(name: Const.sports, url: Const.sportsXML),
        Feed(name: Const.it, url: Const.itXML),
        Feed(name: Const.science, url: Const.scienceXML),
        Feed(name: Const.local, url: Const.localXML)
    ]
    @ObservedObject private var selectFeedDataViewModel = SelectFeedDataViewModel()
    @Environment(\.managedObjectContext)private var context
    var isNavBarHidden = false
    var body: some View {
        let feedDatas = selectFeedDataViewModel.getData(context: context)
        if feedDatas.isEmpty {
            // CoreDataにデータがない時
            NavigationStack {
                List {
                    ForEach(feedlist, id: \.self) { feed in
                        NavigationLink(
                            destination: {
                                NewsListView(url: feed.url)
                            },
                            label: {
                                Text(feed.name)
                            }
                        )
                    }
                }
                .navigationTitle(Const.selectRssFeedViewTitle)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
        } else {
            // CoreDataにデータがある時
            List {
                ForEach(feedlist, id: \.self) { feed in
                    NavigationLink(
                        destination: NewsListView(url: feed.url),
                        label: {
                            Text(feed.name)
                        }
                    )
                }
            }
            .navigationTitle(Const.selectRssFeedViewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .customBackButton()
        }
    }

    init(isNavBarHidden: Bool = false) {
        setupNavigationBar()
        self.isNavBarHidden = isNavBarHidden
    }

    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct SelectRssFeedView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRssFeedView()
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}

struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                        }
                    )
                }
        }
    }
}

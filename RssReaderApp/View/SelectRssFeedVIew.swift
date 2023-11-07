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

    var body: some View {
        NavigationView {
            List{
                ForEach(feedlist, id: \.self) { feed in
                    Button(action: {
                        print("・\(feed.name)ボタン押下")
                    }, label: {
                        Text("・\(feed.name)")
                    })
                }
            }
            .navigationBarTitle("RSSフィード選択画面",displayMode: .inline)
        }
    }

    init() {
        setupNavigationBar()
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

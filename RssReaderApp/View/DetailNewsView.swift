//
//  DetailNewsView.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/13.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let loadUrl: String?

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true

        let configuration  = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let loadUrl = loadUrl, let url = URL(string: loadUrl) else {
            return
        }
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct DetailNewsView: View {
    @ObservedObject private var favoriteFeedDataViewModel = FavoriteFeedDataViewModel()
    @Environment(\.managedObjectContext)private var context
    @State var isFavorite: Bool = false
    var newsItem: NewsItem?
    var body: some View {
        WebView(loadUrl: newsItem?.link ?? "")
        Button(action: {
            guard let newsItem = newsItem else {
                print("newsItem is nil")
                return
            }
            self.isFavorite.toggle()
            favoriteFeedDataViewModel.newsItem = newsItem
            favoriteFeedDataViewModel.writeData(context: context)
        }, label: {
            if self.isFavorite {
                Text(Const.detailCancellRegisteFavorite)
            } else {
                Text(Const.detailRegisterFavorite)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: 44)
        .background(Color(UIColor.lightGray))
        .onAppear() {
            let favoriteDatas = favoriteFeedDataViewModel.getAllData(context: context)
            for favoriteData in favoriteDatas {
                if newsItem?.guid == favoriteData.guid {
                    isFavorite = true
                }
            }
        }
    }

    init(newsItem: NewsItem? = nil) {
        self.newsItem = newsItem
    }
}

struct DetailNewsView_preview: PreviewProvider {
    static var previews: some View {
        DetailNewsView()
    }
}

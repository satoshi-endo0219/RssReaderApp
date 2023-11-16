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
    enum TabSelection {
        case none
        case addFavorite
        case share
    }
    @State private var selection: TabSelection = .none
    @ObservedObject private var favoriteFeedDataViewModel = FavoriteFeedDataViewModel()
    @ObservedObject private var alreadyNewsDataViewModel = AlreadyReadNewsDataViewModel()
    @Environment(\.managedObjectContext)private var context
    @State var isFavorite: Bool = false
    @State private var isPresentActivityController = false
    var newsItem: NewsItem?
    var body: some View {
        WebView(loadUrl: newsItem?.link ?? "")
        HStack() {
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
            Button(action: {
                isPresentActivityController.toggle()
            }, label: {
                Text("シェア")
            })
            .sheet(isPresented: $isPresentActivityController) {
                if let newsItem = newsItem, let shareUrl = URL(string: newsItem.link) {
                    ActivityView(activityItems: [newsItem.title, shareUrl],
                                 applicationActivities: nil)
                    .presentationDetents([.medium, .large])
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: 44)
        .background(Color(UIColor.lightGray))
        .onAppear() {
            let favoriteDatas = favoriteFeedDataViewModel.getAllData(context: context)
            for favoriteData in favoriteDatas {
                if newsItem?.guid == favoriteData.guid {
                    isFavorite = true
                }
            }
            alreadyNewsDataViewModel.guid = newsItem?.guid ?? ""
            alreadyNewsDataViewModel.writeData(context: context)
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

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

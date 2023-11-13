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
    let loadUrl: String?

    var body: some View {
        WebView(loadUrl: loadUrl)
    }

    init(url: String? = nil) {
        self.loadUrl = url
    }
}

struct DetailNewsView_preview: PreviewProvider {
    static var previews: some View {
        DetailNewsView()
    }
}

//
//  LaunchScreen.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/02.
//

import SwiftUI

struct LaunchScreen: View {
@State var isActive = false
    @ObservedObject private var selectFeedDataViewModel = SelectFeedDataViewModel()
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        VStack {
            if isActive {
                let feedDatas = selectFeedDataViewModel.getData(context: context)
                if feedDatas.isEmpty {
                    SelectRssFeedView()
                } else {
                    let url = selectFeedDataViewModel.getUrlFromCoreData(feedDatas: feedDatas)
                    NewsListView(url: url)
                }
            }else {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                .padding()
                Text(Const.splashText)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

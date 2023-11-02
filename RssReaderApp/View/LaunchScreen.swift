//
//  LaunchScreen.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/02.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            .padding()
            Text("RSSReaderApp")
                .foregroundColor(.red)
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

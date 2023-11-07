//
//  LaunchScreen.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/02.
//

import SwiftUI

struct LaunchScreen: View {
@State var isActive = false

    var body: some View {
        VStack {
            if isActive {
                SelectRssFeedView()
            }else {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                .padding()
                Text(Const.SplashText)
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

//
//  ContentView.swift
//  BB Quotes
//
//  Created by iM on 23/12/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuoteView(show: "Breaking Bad")
                .tabItem { Label("breaking bad", systemImage: "tortoise") }
            QuoteView(show: "Better Call Saul")
                .tabItem { Label("better call saul", systemImage: "briefcase")
                }
        }
        .onAppear {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
        }
    }
}

#Preview {
    ContentView()
}

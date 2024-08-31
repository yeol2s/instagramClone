//
//  MainTabView.swift
//  instagramClone
//
//  Created by 유성열 on 9/1/24.
//
// MARK: - 탭뷰

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView { // 탭바 생성
            Text("Feed") // 탭바 눌렀을 때 나올 View
                .tabItem {
                    Image(systemName: "house")
                }
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            Text("NewPost")
                .tabItem {
                    Image(systemName: "plus.square")
                }
            Text("Reels")
                .tabItem {
                    Image(systemName: "movieclapper")
                }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.circle")
                }
        } //:TabView
    }
}

#Preview {
    MainTabView()
}

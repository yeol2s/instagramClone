//
//  MainTabView.swift
//  instagramClone
//
//  Created by 유성열 on 9/1/24.
//
// MARK: - 탭뷰

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    
    // tag를 관리해줄 변수(초기값에 따라 첫 시작화면 탭뷰도 결정이 됨) -> tabIndex로 탭을 변경할 수 있게된다.
    @State var tabIndex = 0
    
    var body: some View {
        TabView(selection: $tabIndex) { // 탭바 생성(tabIndex를 인자로 받아서 탭을 관리하기 위해 인자로 selection을 받음) -> 바인딩을 해줘야함 탭이 바뀔때 tabIndex가 해당 tag로 변경되어 받음
            Text("Feed") // 탭바 눌렀을 때 나올 View
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0) // 각각의 탭들을 이름을 붙여주는 것(숫자)
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            NewPostView(tabIndex: $tabIndex) // 뒤로가기시 홈뷰로 갈 수 있도록 tabIndex 바인딩
                .tabItem {
                    Image(systemName: "plus.square")
                }
                .tag(2)
            // TODO: 임시 로그아웃(테스트)
            VStack {
                Text("Reels")
                Button {
                    AuthManager.shared.signout() // 로그아웃
                } label: {
                    Text("로그아웃")
                }
            }
            .tabItem {
                Image(systemName: "movieclapper")
            }
            .tag(3)
            ProfileView() // 프로필뷰
                .tabItem {
                    Image(systemName: "person.circle")
                }
                .tag(4)
        } //:TabView
        .tint(Color.black) // 탭바들 전체 컬러 설정
    }
}

#Preview {
    MainTabView()
}

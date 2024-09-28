//
//  FeedView.swift
//  instagramClone
//
//  Created by 유성열 on 9/23/24.
//
// MARK: - FeedView(서버에 올린 게시글들을 보여주는 뷰)

import SwiftUI

struct FeedView: View {
    @State var viewModel = FeedViewModel()
    
    var body: some View {
        // FeedView에서 유저정보를 클릭했을 때 해당 유저의 프로필(팔로우버튼 있는)로 넘어갈 수 있도록 네비게이션 스택으로(NaviLink는 FeedCellView에서)
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Image("instagramLogo2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                        Spacer()
                        Image(systemName: "heart")
                            .imageScale(.large)
                        Image(systemName: "paperplane")
                            .imageScale(.large)
                    } //:HSTACK
                    .padding(.horizontal)
                    
                    LazyVStack { // Lazy하게(ForEach만 사용하면 Post 전체 로드됨 - 메모리 낭비 및 데이터 많을시 앱 버벅임)
                        ForEach(viewModel.posts) { post in
                            // 여기서 Post를 하위뷰(FeedCellView)로 넘겨줌
                            FeedCellView(post: post) // 뷰모델로 부터 받은 Post 전달
                        }
                    }
                    
                    Spacer()
                } //:VSTACK
            }  //:SCROLL
            // MARK: 스크롤 뷰 새로고침
            // .task는 내가 게시물을 올릴때 새로고침할 때 유용하고 .refreshable은 내가 현재 뷰에 머물러 있을때 다른 유저의 게시물이 올라올 때 스와이프로 새로고침이 되므로 유용함
            .refreshable { // 아래로 스와이프해서 새로고침할 수 있음(당기면 refreshable에 할당된 코드가 실행됨
                // MARK: refreshable 자체가 비동기적으로 동작하므로 따로 Task로 감싸지않아도 됨
                await viewModel.loadAllPosts()
            }
            .task { // (뷰 생명주기)뷰 생성, 뷰 상태 변경시 자동실행(비동기 작업 수행)
                await viewModel.loadAllPosts()
            }
        } //:NAVIGATION
    }
}

#Preview {
    FeedView()
}

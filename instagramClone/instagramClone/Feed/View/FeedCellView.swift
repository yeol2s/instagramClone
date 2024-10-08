//
//  FeedCellView.swift
//  instagramClone
//
//  Created by 유성열 on 9/23/24.
//
// MARK: - FeedCellView(게시물들을 보여주기 위한 뷰, 재사용 셀)
// 이미지, 게시글, 시간등 하나의 게시글을 보여주는 셀

import SwiftUI
import Kingfisher

struct FeedCellView: View {
    // MARK: FeedCellViewModel을 따로 만들긴 했지만 이게 만약 추가되는 로직들이 없고 간단하게 Post 데이터만 불러오는 경우에는, 뷰모델의 내용물이 거의 없을때는 뷰모델을 굳이 만들지않고 모델을 그대로 사용하기도 한다.("쓰기가 없고 데이터를 읽기만 한다면") - 예제에서는 로직이 추가되므로 뷰모델 생성
    // let post: Post
    
    @State var viewModel: FeedCellViewModel
    @State var isCommentShowing = false // (상태)Bool값에 따라 댓글창 띄울지 결정
    
    // View 생성자로 ViewModel을 받는게 아닌 Post를 받음(넘겨받는건 Post 알맹이다! 뷰모델은 내가만든다)
    init(post: Post) {
        self.viewModel = FeedCellViewModel(post: post) // 여기서 뷰모델에 post를 넣어줌
    }
    
    var body: some View {
        VStack {
            KFImage(URL(string: viewModel.post.imageUrl))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .overlay(alignment: .top) { // 이미지 위에 사용자 아이콘, 햄버거메뉴를 올리기 위함(ZStack도 가능) overlay를 alignment top 설정(상단 배치)
                    HStack {
                        // 유저 정보를 클릭해서 대상의 프로필을 보기위해 NaviLink
                        NavigationLink {
                            if let user = viewModel.post.user {
                                // ProfileViewModel()은 현재 로그인된 유저가 세팅되는 것이고, ProfileViewModel(user:)는 다른 유저의 프로필 정보를 세팅하기 위해 생성자 추가 정의
                                ProfileView(viewModel: ProfileViewModel(user: user))
                            }
                        } label: {
                            KFImage(URL(string: viewModel.post.user?.profileImageUrl ?? ""))
                                .resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color(red: 191/255, green: 11/255, blue: 180/255), lineWidth: 2) // 테두리
                                }
                            Text("\(viewModel.post.user?.username ?? "")")
                                .foregroundStyle(.white)
                                .bold()
                        }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.white)
                            .imageScale(.large)
                    } //:HSTACK
                    .padding(5)
                }
            
            HStack {
                // '좋아요' 기능
                let isLike = viewModel.post.isLike ?? false
                Button {
                    Task {
                        // if문 대신 삼항연산자로 구현
                        isLike ? await viewModel.unlike() : await viewModel.like()
                    }
                } label: {
                    Image(systemName: isLike ? "heart.fill" : "heart")
                        .foregroundStyle(isLike ? .red : .primary)
                }
                // 댓글 아이콘
                Button {
                    isCommentShowing = true
                } label: {
                    Image(systemName: "bubble.right")
                }
                .tint(.black) // 최상위뷰에서 틴트가 블랙으로 설정되어있으므로 생략가능
                Image(systemName: "paperplane")
                Spacer()
                Image(systemName: "bookmark")
            } //:HSTACK
            .imageScale(.large) // 스택내 Image 전부 크기 조정
            .padding(.horizontal)
            Text("좋아요 \(viewModel.post.like)개")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Text("\(viewModel.post.user?.username ?? "")" + " " + viewModel.post.caption) // 게시글 내용
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            // 댓글(더보기)
            Button {
                isCommentShowing = true
            } label: {
                Text("댓글 \(viewModel.commentCount)개 더보기")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            Text("\(viewModel.post.date.relativeTimeString())")
                .foregroundStyle(.gray)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        } //:VSTACK
        .padding(.bottom) // FeedView에서 셀간 간격을 위해 하단에 패딩
        // (isCommentShowing 값에 따라)sheet으로 댓글창 띄움
        .sheet(isPresented: $isCommentShowing, content: {
            CommentView(post: viewModel.post) // 뷰모델 내부의 post를 전달
                .presentationDragIndicator(.visible) // 드래그 힌트바 보이게
        })
        // 댓글 올렸다가 내릴때 감지되도록 해서 댓글 카운트가 다시 로드되도록
        .onChange(of: isCommentShowing) { oldValue, newValue in
            // 댓글창이 열렸다가 닫힐때(isCommentShowing이 true->false 바뀔 때)
            if newValue == false {
                Task {
                    await viewModel.loadCommentCount()
                }
            }
        }
    }
}

#Preview {
    FeedCellView(post: Post(id: "yVIK4VuUEUvfuQQr4flP", userId: "HirGz6G7ZFVMMybY6GnSKvKnQHh1", caption: "멍멍", like: 0, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagramclone-c957d.appspot.com/o/images%2F75793E6D-3FCC-4351-BDD1-E5A2AF90CC46?alt=media&token=25d723d2-00d3-4809-a8e7-a1b7160f9d70", date: Date()))
}

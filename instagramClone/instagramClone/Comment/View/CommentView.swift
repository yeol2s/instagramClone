//
//  CommentView.swift
//  instagramClone
//
//  Created by 유성열 on 10/5/24.
//
// MARK: - CommentView(댓글 뷰)

import SwiftUI
import Kingfisher

struct CommentView: View {
    @State var commentText = ""
    @State var viewModel: CommentViewModel // FeedCellView에서 (상위)viewModel의 post를 전달받을 것
    
    init(post: Post) {
        self.viewModel = CommentViewModel(post: post)
    }
    
    var body: some View {
        VStack {
            Text("댓글")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 15)
                .padding(.top, 30)
            Divider()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    // 댓글들 가져와서 루프
                    ForEach(viewModel.comments) { comment in
                        CommentCellView(comment: comment)
                            .padding(.horizontal)
                            .padding(.top)
                    }
                } //:VSTACK
            } //:SCROLL
        
            Divider()
            HStack {
                if let imageUrl = AuthManager.shared.currentUser?.profileImageUrl {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                }
                // axis: .vertical - 텍스트가 길어지면 세로로 늘어나도록
                TextField("댓글 추가", text: $commentText, axis: .vertical)
                Button {
                    Task {
                        await viewModel.uploadComment(commentText: commentText) // 댓글 업로드
                        commentText = "" // 입력한 댓글은 지워줌
                    }
                } label: {
                    Text("보내기")
                }
                .tint(.black)
            } //:HSTACK
            .padding()
        } //:VSTACK
    }
}

#Preview {
    CommentView(post: Post.DUMMY_POST) // 더미 포스트 사용
}

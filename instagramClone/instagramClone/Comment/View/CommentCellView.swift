//
//  CommentCellView.swift
//  instagramClone
//
//  Created by 유성열 on 10/7/24.
//
// MARK: - CommentCell View (댓글 보여지는 뷰 - 프로필 이미지, 닉네임등 표시)

import SwiftUI
import Kingfisher

struct CommentCellView: View {
    let comment: Comment // Comment 모델을 전달받음(커맨트를 그리기 위함)
    
    var body: some View {
        HStack {
            if let imageUrl = comment.commentUser?.profileImageUrl {
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
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.commentUser?.username ?? "")
                    Text(comment.date.relativeTimeString())
                        .foregroundStyle(.gray)
                } //:HSTACK
                Text(comment.commentText)
            } //:VSTACK
        } //:HSTACK
    }
}

#Preview {
    CommentCellView(comment: Comment.DUMMY_COMMENT) // 더미 커맨트
}

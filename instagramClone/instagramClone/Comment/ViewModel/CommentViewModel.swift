//
//  CommentViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 10/7/24.
//
// MARK: - CommentViewModel(댓글 뷰모델)

import Foundation

@Observable
class CommentViewModel {
    var comments: [Comment] = [] // 로드해서 가져올 Comment를 여기 담을 것
    var postId: String // CommentView를 생성할 때 postId를 전달받아서 '어떤 게시글에 대한 댓글 창인지' 확인
    var postUserId: String
    
    init(post: Post) {
        self.postId = post.id
        self.postUserId = post.userId
        Task {
            await loadComment() // 모든 댓글 로드
        }
    }
    
    // 댓글 업로드
    func uploadComment(commentText: String) async {
        guard let userId = AuthManager.shared.currentUser?.id else { return }
        // id는 UUID로 직접생성해서 넣어주고 commentUserId는 '현재 로그인한 사람의 id(댓글을 쓰는 유저)'
        let comment = Comment(id: UUID().uuidString, commentText: commentText, postId: postId, postUserId: postUserId, commentUserId: userId, date: Date())
        await CommentManager.uploadComment(comment: comment, postId: postId)
        await loadComment() // 새로고침(댓글 로드)
    }
    
    // (post에 달린 모든 댓글을 가져오도록) 댓글을 업로드 하나라도 하면 모든 댓글들을 (업데이트)로드하도록(새로고침 같이)
    func loadComment() async {
        self.comments = await CommentManager.loadComment(postId: postId)
        
        // 현재 Comment는 commentUser 속성이 비어있다.(옵셔널) 댓글들을 제대로 보여주기 위해 (프로필이미지, 닉네임 등)유저에 대한 정보를 User에서 가져와서 세팅해줘야 함
        for i in 0..<comments.count {
            let user = await AuthManager.shared.loadUserData(userId: comments[i].commentUserId)
            comments[i].commentUser = user // comments[i]의 commentUser를 가져온 user로 세팅함
        }
    }
}

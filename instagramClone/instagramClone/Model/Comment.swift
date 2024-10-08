//
//  Comment.swift
//  instagramClone
//
//  Created by 유성열 on 10/6/24.
//
// MARK: - Comment Model

import Foundation

struct Comment: Codable, Identifiable {
    let id: String // 댓글을 식별할 수 있는 id
    let commentText: String // 댓글 내용
    
    // 게시글에 대한 정보
    let postId: String // 댓글이 달린 게시글에 대한 정보 저장(게시글 id)
    let postUserId: String // 게시글을 작성한 유저의 id
    // 댓글을 작성한 유저의 정보
    let commentUserId: String
    var commentUser: User? // 우선 위의 id만 저장해놓았다가 유저에 대한 정보는 나중에 로딩해서 가져올 수 있도록 옵셔널
    
    let date: Date // 댓글이 작성된 시간
}

// 더미 커맨트
extension Comment {
    static var DUMMY_COMMENT: Comment = Comment(id: UUID().uuidString, commentText: "test comment", postId: UUID().uuidString, postUserId: UUID().uuidString, commentUserId: UUID().uuidString, date: Date())
}

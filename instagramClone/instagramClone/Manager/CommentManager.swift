//
//  CommentManager.swift
//  instagramClone
//
//  Created by 유성열 on 10/6/24.
//
// MARK: - CommentManager(댓글 매니저)
// 댓글을 로드 및 업로드 관리 매니저

import Foundation
import Firebase

class CommentManager {
    // 댓글 업로드(comment: 커맨트를 받고, postId: 어떤 게시글에 이 커맨트를 올릴 것인지)
    static func uploadComment(comment: Comment, postId: String) async {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return } // comment를 Firebase에 전송할 수 있는 규격으로 인코딩 변환
        do {
            try await Firestore.firestore()
                .collection("posts")
                .document(postId)
                .collection("post-comment")
                .addDocument(data: commentData) // posts 컬렉션의 postId에 접근해서 "post-comment'컬렉션을 새로만들고 commentData document를 추가
        } catch {
            print("DEBUG: Failed to upload comment with error \(error.localizedDescription)")
        }
    }
    // 댓글 로드(해당 post에 달린 모든 댓글을 가져옴)
    static func loadComment(postId: String) async -> [Comment] {
        do {
            // documents에 문서들이 배열로 저장됨
            let documents = try await Firestore.firestore()
                .collection("posts")
                .document(postId)
                .collection("post-comment")
                .order(by: "date", descending: true) // order로 순서를 정렬해서 가져옴(by: date 필드를 기준으로 - 내림차순)
                .getDocuments()
                .documents // 가져온 문서를 배열로?
            let comments = documents.compactMap { document in
                try? document.data(as: Comment.self) // document를 Comment 형식으로 변환
            }
            return comments
        } catch {
            print("DEBUG: Failed to load comment with error \(error.localizedDescription)")
            return [] // 실패시에는 빈배열 반환
        }
    }
    
    // 댓글 개수만 가져오기
    static func loadCommentCount(postId: String) async -> Int {
        do {
            // documents에 문서들이 배열로 저장됨
            let documents = try await Firestore.firestore()
                .collection("posts")
                .document(postId)
                .collection("post-comment")
                .getDocuments()
                .documents
            
            return documents.count // 문서의 배열개수 리턴
        } catch {
            print("DEBUG: Failed to load comment count with error \(error.localizedDescription)")
            return 0 // 실패시에는 0개
        }
    }
}

//
//  PostManager.swift
//  instagramClone
//
//  Created by 유성열 on 10/2/24.
//
// MARK: - PostManager
// '좋아요' 기능을 관리할 게시글 매니저
// 기존 Post 통신 관련 코드들을 여기로 가져오는 작업 진행(리팩토링)

import Foundation
import FirebaseFirestore

class PostManager {
    // Feed에 있는 모든 Post를 가져올 것(다른 유저들 것 까지)
   static func loadAllPosts() async -> [Post]? {
        do {
            let documents = try await Firestore.firestore().collection("posts").order(by: "date", descending: true)
                .getDocuments().documents // 모든 documnets를 다 가져오도록
            // MARK: (에러해결) 이 부분에서 테스트시 data로 Decodable을 정상적으로 하지 못하고 에러를 뱉는 문제가 발생했었는데 이유는 게시물중 이전에 작성된 userId(UID)가 없는 게시물들이 문제가 되는 것으로 UID없는 게시물들을 파베 Document에서 삭제해주니 정상적으로 작동함
            let posts = try documents.compactMap { try $0.data(as: Post.self) }
            
            return posts
        } catch {
            print("DEBUG: Failed to load user posts with error \(error.localizedDescription)")
            return nil
        }
    }
    
    // Posts 데이터들 가져오기(Manager는 User에 대해서 모른다. 그래서 뷰모델에게 user를 인자로 받음)
    static func loadUserPosts(userId: String) async -> [Post]? {
        // Document중에서 userId가 현재 Id와 같은 것들을 가져와야 하므로 whereField(field: isEqualTo:)사용(isEqualTo: userId 필드가 (프로퍼티)user?.id와 같은지 체크)
        // .order(by: date필드, descending: 내림차순-true) 로 포스트 정렬
        do {
            let documents = try await Firestore.firestore().collection("posts").order(by: "date", descending: true)
                .whereField("userId", isEqualTo: userId).getDocuments().documents
            
            // post를 임시저장
            var posts: [Post] = []
            // documents에 있는 데이터들을 Post 타입으로 변환하기 위한 루프
            for document in documents {
                let post = try document.data(as: Post.self) // Post 타입으로 변경해서 post에 담음(as: 원하는 타입)
                posts.append(post)
            }
            return posts // 변형한 post 배열을 전달
        } catch {
            print("DEBUG: Failed to load user posts with error \(error.localizedDescription)")
            return nil
        }
    }
}

// '좋아요' 기능 확장
extension PostManager {
    // post를 인자로 받음(해당 포스트를 '좋아요' 할 것)
    static func like(post: Post) async {
        guard let userId = AuthManager.shared.currentUser?.id else { return }
        
        // Post DB, User DB 모두 접근(양쪽에 '좋아요'하는 게시글과, '좋아요'하는 유저를 추가하기 위함)
        let postsCollection = Firestore.firestore().collection("posts") // (해당 컬렉션을 접근하기 위한)재사용 위한 형식
        let usersCollection = Firestore.firestore().collection("users") // 상동
        
        // 현재 유저가 좋아하는 게시글이 누군지를 추가
        async let _ = usersCollection.document(userId).collection("user-like").document(post.id).setData([:]) // 현재 userId의 DB 접근해서 "user-like" 컬렉션 만들고, 그 게시글은 post.id로 저장
        // 게시글을 어떤 사용자들이 좋아하는지를 추가
        async let _ = postsCollection.document(post.id).collection("post-like").document(userId).setData([:])
        // '좋아요' 개수 업데이트(+)
        async let _ = postsCollection.document(post.id).updateData(["like": post.like + 1]) // 'like'라는 키값에 'post.like + 1'을 해서 저장
    }
    
    static func unlike(post: Post) async {
        guard let userId = AuthManager.shared.currentUser?.id else { return }
        
        // Post DB, User DB 모두 접근(양쪽에 '좋아요'하는 게시글과, '좋아요'하는 유저를 추가하기 위함)
        let postsCollection = Firestore.firestore().collection("posts") // (해당 컬렉션을 접근하기 위한)재사용 위한 형식
        let usersCollection = Firestore.firestore().collection("users") // 상동
        
        // 현재 유저가 좋아하는 게시글이 누군지를 추가했던 것을 -> 삭제
        async let _ = usersCollection.document(userId).collection("user-like").document(post.id).delete()
        // 게시글을 어떤 사용자들이 좋아하는지를 추가했던 것을 -> 삭제
        async let _ = postsCollection.document(post.id).collection("post-like").document(userId).delete()
        // '좋아요' 개수 업데이트(-)
        async let _ = postsCollection.document(post.id).updateData(["like": post.like - 1])
    }
    
    // 해당 게시글을 현재 유저가 '좋아요'하는지를 체크
    static func checkLike(post: Post) async -> Bool {
        guard let userId = AuthManager.shared.currentUser?.id else { return false }
        
        // (posts 컬렉션도 가능) users 컬렉션에 접근해서 '좋아요'하는 대상에 post.id가 있는지를 체크
        do {
            let isLike = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("user-like") // user-like 컬렉션 접근
                .document(post.id)
                .getDocument()
                .exists // user-like 컬렉션에 해당 post.id가 존재하는지 -> Bool
            return isLike
        } catch {
            print("DEBUG: Failed to check like with error \(error.localizedDescription)")
            return false
        }
    }
    
}

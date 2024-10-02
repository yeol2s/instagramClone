//
//  FeedViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/24/24.
//
// MARK: - FeedViewModel(게시글 피드 뷰모델)
// (사진)게시물들을 서버에서 가져와서 보여주기 위한 뷰모델

import Foundation
import Firebase

@Observable
class FeedViewModel {
    
    var posts: [Post] = []
    
    init() {
        Task {
            await loadAllPosts() // 뷰모델 생성시 게시물 가져올 수 있도록 로드
        }
    }
    
    // (Old)Feed에 있는 모든 Post를 가져올 것(다른 유저들 것 까지)
    // MARK: (Old) PostManager로 이동(리팩토링)
    //    func loadAllPosts() async {
    //        do {
    //            let documents = try await Firestore.firestore().collection("posts").order(by: "date", descending: true)
    //                .getDocuments().documents // 모든 documnets를 다 가져오도록
    //
    //            // MARK: (Old)
    //            // 방법 1.
    ////            var posts: [Post] = []
    ////            // documents에 있는 데이터들을 Post 타입으로 변환하기 위한 루프
    ////            for document in documents {
    ////                let post = try document.data(as: Post.self) // Post 타입으로 변경해서 post에 담음(as: 원하는 타입)
    ////                posts.append(post)
    ////            }
    ////            self.posts = posts // 변형한 post 배열을 전달
    //            // MARK: (New) 위 코드 더 깔끔하게
    //            // 방법 2. map
    ////            self.posts = try documents.map({ document in
    ////                return try document.data(as: Post.self)
    ////            })
    //            // 축약
    ////            self.posts = try documents.map { try $0.data(as: Post.self) }
    //            // 방법 3. compactMap(documents 배열내의 nil은 버림 - 옵셔널 제거)
    ////            self.posts = try documents.compactMap({ document in
    ////                return try document.data(as: Post.self)
    ////            })
    //            // 축약
    //            // MARK: (에러해결) 이 부분에서 테스트시 data로 Decodable을 정상적으로 하지 못하고 에러를 뱉는 문제가 발생했었는데 이유는 게시물중 이전에 작성된 userId(UID)가 없는 게시물들이 문제가 되는 것으로 UID없는 게시물들을 파베 Document에서 삭제해주니 정상적으로 작동함
    //            self.posts = try documents.compactMap { try $0.data(as: Post.self) }
    //
    //        } catch {
    //            print("DEBUG: Failed to load user posts with error \(error.localizedDescription)")
    //        }
    //    }
    
    // (New)Feed에 있는 모든 Post를 가져옴(다른 유저들 것 까지)
    func loadAllPosts() async {
        guard let posts = await PostManager.loadAllPosts() else { return }
        self.posts = posts
    }
}

//
//  UserCountManager.swift
//  instagramClone
//
//  Created by 유성열 on 10/9/24.
//
// MARK: - UserCountManager
// 팔로워, 팔로잉수 게시물수 등 숫자에 대한 정보 서버에서 가져옴

import Foundation
import Firebase

// 튜플 대신 값을 한번에 반환하기 위한 타입
struct UserCountInfo: Codable { // UserCountInfo는 우리가 직접 만든 타입이므로 Codable 프로토콜을 채택해야 User 모델에서 사용할 수 있다.
    var postCount: Int
    var followingCount: Int
    var followerCount: Int
}

class UserCountManager {
    static func loadUserCountInfo(userId: String?) async -> UserCountInfo? {
        guard let userId else { return nil }
        
        do {
            // MARK: 아래 count를 하는 작업들은 각각 순서가 필요없으므로 각자 async let을 사용해서 병렬적으로 동시에 비동기 작업을할 수 있도록함
            // 팔로잉 수
            async let followingDocuments = try await Firestore.firestore()
                .collection("following")
                .document(userId)
                .collection("user-follwing")
                .getDocuments() // userId의 "user-following" 컬렉션에 접근해서 데이터를 가져온다.
            let follwoingCount = try await followingDocuments.count
            
            // 팔로워 수
            async let followerDocuments = try await Firestore.firestore()
                .collection("follower")
                .document(userId)
                .collection("user-follower")
                .getDocuments()
            let followerCount = try await followerDocuments.count
            
            // 게시글 수
            async let postDocuments = try await Firestore.firestore()
                .collection("posts")
                .whereField("userId", isEqualTo: userId) // 게시글이 post id들로 키값이 저장되어 있기 때문에 userId로 찾으려면 whereField를 사용해야함("userId 필드에서 현재 userId와 같은 값들을 찾아줘")
                .getDocuments()
            let postCount = try await postDocuments.count
            
            return UserCountInfo(postCount: postCount, followingCount: follwoingCount, followerCount: followerCount)
        } catch {
            print("DEBUG: Failed to load user count with error \(error.localizedDescription)")
            return nil
        }
    }
}

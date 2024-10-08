//
//  User.swift
//  instagramClone
//
//  Created by 유성열 on 9/16/24.
//
// MARK: - User Model(데이터 전달-인코딩)
import Foundation
import FirebaseAuth

struct User: Codable, Identifiable { // Identifiable을 채택함으로써 id로 구분할 수 있게(ForEach에서)
    let id: String // 사용자 UID
    let email: String
    var username: String
    var name: String
    var bio: String? // 간단한 자기소개(회원가입때는 입력하지 않으므로 옵셔널)
    var profileImageUrl: String? // 프로필 이미지 주소(상동으로 옵셔널)
    var isFollowing: Bool? // 현재 로그인한 유저가 이 유저를 팔로잉하고 있는지에 대한 여부(서버에서 가져오는 데이터들을 항상 가져오기보다 로컬에서 처리할 수 있도록)
    
    // 게시글, 팔로워, 팔로잉 수 저장할 변수
    var userCountInfo: UserCountInfo? // UserCountInfo는 우리가 직접 만든 타입이므로 Codable 프로토콜을 채택해야 사용할 수 있다.
    
    // (계산속성) id가 현재 로그인된 id와 비교하여 현재 아이디인지 아닌지를 구분하여 반환(프로필 뷰에서 '프로필 편집' or '팔로우'를 결정하기 위함)
    var isCurrentUser: Bool {
        //guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        guard let currentUserId = AuthManager.shared.currentUser?.id else { return false } // 바인딩이 안되면 현재 유저가 아니니 바로 false 반환
//        if id == currentUserId { // id에는 현재 로그인된 유저의 id가 담겨있을 것
//            return true
//        } else {
//            return false
//        }
        // 실제 앱 단위에서 로그인된 환경과 파이어베이스 서버에 접속되어 있는 상태의 id를 비교하는 것?
        return id == currentUserId // 간단하게(현재 로그인되어 있는 id와 바인딩된 id비교하여 -> Bool)
    }
}

// 더미 유저
extension User {
    static var DUMMY_USER: User = User(id: UUID().uuidString, email: "dummy@gmail.com", username: "dummy", name: "dummy")
}

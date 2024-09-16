//
//  User.swift
//  instagramClone
//
//  Created by 유성열 on 9/16/24.
//
// MARK: - 유저 모델(데이터 전달-인코딩)
import Foundation

struct User: Codable {
    let id: String // 사용자 UID
    let email: String
    var username: String
    var name: String
    var bio: String? // 간단한 자기소개(회원가입때는 입력하지 않으므로 옵셔널)
    var profileImageUrl: String? // 프로필 이미지 주소(상동으로 옵셔널)
}

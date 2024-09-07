//
//  Post.swift
//  instagramClone
//
//  Created by 유성열 on 9/8/24.
//
import Foundation

// MARK: - (Post)Model(게시글 정보에대한 모델)
struct Post: Codable { // (Encodable)Firebase에 보내기도 해야하고, (Decodable)Firebase에 있는 데이터를 여기로 가져와서 해독도 해야하므로 -> Codable 프로토콜 채택
    let id: String // 게시글을 업로드하고 가져올때 필요한 식별자 id(문구나 사진으로 구분하면 중복되는 문구, 사진을 구분할 수 없음)
    let caption: String // 게시글에 들어갈 문구
    var like: Int // 좋아요에 대한 숫자를 저장
    let imageUrl: String // 이미지에 대한 정보
    let date: Date // 시간 저장
}

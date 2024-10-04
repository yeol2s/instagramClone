//
//  Post.swift
//  instagramClone
//
//  Created by 유성열 on 9/8/24.
//
// MARK: - (Post)Model(게시글 정보에대한 모델)
import Foundation

// id로 식별할 수 있도록 Identifiable 프로토콜 채택
struct Post: Codable, Identifiable { // (Encodable)Firebase에 보내기도 해야하고, (Decodable)Firebase에 있는 데이터를 여기로 가져와서 해독도 해야하므로 -> Codable 프로토콜 채택
    let id: String // 게시글을 업로드하고 가져올때 필요한 식별자 id(문구나 사진으로 구분하면 중복되는 문구, 사진을 구분할 수 없음)
    let userId: String // 게시글에 들어갈 UID(Firebase Auth UID의 값이 들어갈 것)
    let caption: String // 게시글에 들어갈 문구
    var like: Int // 좋아요에 대한 숫자를 저장
    let imageUrl: String // 이미지에 대한 정보
    let date: Date // 시간 저장
    var isLike: Bool? // '좋아요'(서버에서 가져오는 데이터들을 항상 가져오기보다 로컬에서 처리할 수 있도록)
    
    // 유저에 대한 정보 가져오기 위한 user 변수(Firebase에서 userId 기반으로 post를 올린 유저를 식별해서 저장하기 위함)
    var user: User? // 옵셔널인 이유는 처음 Firebase의 posts랑 통신할 때는 해당 정보를 제외하기 때문(나중에 유저정보를 가져와서 채움)
}

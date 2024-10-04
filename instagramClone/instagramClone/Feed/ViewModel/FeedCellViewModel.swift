//
//  FeedCellViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/24/24.
//
// MARK: - FeedCellViewModel(셀 뷰모델)
// FeedCell에 대한 뷰모델

import Foundation

@Observable
class FeedCellViewModel {
    var post: Post // 상위 뷰모델로부터 전달받은 Post를 여기에 장착(FeedView에서 넘겨받음)
    
    init(post: Post) {
        self.post = post
        Task {
            await loadUserData() // FeedCellView가 생성될 때 post 내부에 user가 세팅되도록
            await checkLike() // '좋아요' 체크
        }
    }
    
    func loadUserData() async {
        let userId = post.userId // userId 가져오고
        guard let user = await AuthManager.shared.loadUserData(userId: userId) else { return }
        post.user = user // post user에 값으로 userId 기준 유저데이터를 넣어줌(post의 유저 식별 위함)
    }
}

// '좋아요' 기능 확장
extension FeedCellViewModel {
    // MARK: like, unlike는 뷰에서 '좋아요'가 체크되거나 해제되는데 앱을 켤 때(서버에서 가져올 때)는 checkLike
    
    func like() async {
        await PostManager.like(post: post) // 현재 post를 '좋아요'함
        post.isLike = true // (로컬 저장)isLike true
        post.like += 1 // (로컬)like 증가
    }
    
    func unlike() async {
        await PostManager.unlike(post: post) // 현재 post를 '좋아요'해제
        post.isLike = false
        post.like -= 1
    }
    
    func checkLike() async {
        post.isLike = await PostManager.checkLike(post: post) // 현재 post를 '좋아요'하는지 체크 (체크한 Bool값은 isLike에 저장)
    }
}



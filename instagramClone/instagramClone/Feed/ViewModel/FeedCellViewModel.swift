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
        }
    }
    
    func loadUserData() async {
        let userId = post.userId // userId 가져오고
        guard let user = await AuthManager.shared.loadUserData(userId: userId) else { return }
        post.user = user // post user에 값으로 userId 기준 유저데이터를 넣어줌(post의 유저 식별 위함)
    }
}

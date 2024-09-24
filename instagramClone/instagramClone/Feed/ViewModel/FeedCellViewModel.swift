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
    }
    
    
}

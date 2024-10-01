//
//  SearchViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/30/24.
//
// MARK: - SearchViewModel

import Foundation

@Observable
class SearchViewModel {
    var users: [User] = [] // 올유저를 받음
    
    init() {
        Task {
            await loadAllUserData()
        }
    }
    
    func loadAllUserData() async { // 모든유저 로드
        self.users = await AuthManager.shared.loadAllUserData() ?? []
    }
}

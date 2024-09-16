//
//  ProfileViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/17/24.
//
// MARK: - ProfileViewModel(프로필뷰모델)
// 프로필에서 화면에 유저정보 데이터(사진, 이름, 소개등)를 가져와서 뷰에 전달해야 함
// 데이터는 AuthManager에 currentUser가 가지고 있음
import Foundation

@Observable
class ProfileViewModel {
    var user: User? // user 내부는 감지가 불가능함(모델이고 내부에 @State와 같은 선언이 안되어있으므로)
    
    // 프로필편집뷰(ProfileEditingView)에서 텍스트필드에서 바인딩(감지 가능하도록)이 될 수 있도록 감지 가능한 프로퍼티들(currentUser에서 빼내와서 초기화)
    var name: String
    var username: String
    var bio: String
    
    init() {
        // MARK: let user에 할당 후 user(프로퍼티)를 초기화 시키는 이유는 이 생성자에서 바인딩을 위해 유저정보를 아래에서 프로퍼티에 초기화시키고 있는데 생성자내에서 (프로퍼티)user를 초기화시키면서 동시에 다른 프로퍼티(name, username, bio)에 (프로퍼티)user를 가져다 쓸 수 없다.(금지되어있음) 그래서 생성자내에서 (상수)user를 만들고 (프로퍼티)user를 초기화 시킴과 동시에 나머지 프로퍼티를 user로 초기화시킴
        // 생성자내에서 가장 가까운 (상수)user를 가져다가 프로퍼티들을 초기화시킨다. *(상수)user 이름을 변경해서 구분해도 되긴함(ex: tempUser)
        let user = AuthManager.shared.currentUser // 생성시 (싱글톤)AuthManager에 있는 currentUser를 전달
        self.user = user // currentUser를 user에 장착
        
        // 프로필편집뷰에서 바인딩 위해 user에서 꺼내서 별도로 프로퍼티 초기화
        self.name = user?.name ?? ""
        self.username = user?.username ?? ""
        self.bio = user?.bio ?? ""
    }
    
    
}

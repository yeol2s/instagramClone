//
//  SignupViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/13/24.
//
// MARK: - ViewModel(회원가입)
// 회원가입시 유저정보(메일, 패스워드, 이름, 닉네임)를 입력받고 관리(저장)할 뷰모델

import Foundation
import FirebaseAuth

@Observable // 뷰모델 속성들을 감시할 수 있게 @Observable 매크로 설정
class SignupViewModel {
    var email = ""
    var password = ""
    var name = ""
    var username = ""
    
    
    // 회원가입(싱글톤 AuthManger로 유저정보 전달)
    func createUser() async {
        await AuthManager.shared.createUser(email: email, password: password, name: name, username: username) // 계정 생성
        email = ""
        password = ""
        name = ""
        username = ""
    }
    
}

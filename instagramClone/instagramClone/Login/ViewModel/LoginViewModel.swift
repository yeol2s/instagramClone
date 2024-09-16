//
//  LoginViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/16/24.
//
// MARK: - LoginViewModel (로그인 뷰모델)
import Foundation

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    
    // 로그인 메서드(로그인 정보를 받아서 AuthManager로 전달하여 처리)
    func signIn() async{
        await AuthManager.shared.signIn(email: email, password: password)
    }
}



//
//  AuthManager.swift
//  instagramClone
//
//  Created by 유성열 on 9/14/24.
//
// MARK: - AuthManger(싱글톤)
// 회원가입과 로그인에 관련된 즉 인증에 관한 것들의 매니저(관리 역할)

import Foundation
import FirebaseAuth

@Observable // @Observable 매크로 설정
class AuthManager {
    
    static let shared = AuthManager()
    
    // Auth.auth().currentUser : 회원가입이나 로그인을 하면 currentUser에 로그인된 사용자값이 세팅된다.(이것으로 로그인이 됐는지 안됐는지 파악)
    // Auth.auth().currentUser으로 접근하는 것은 Firebase에서 제공하는 것이므로 자체로는 @State와 같은 상태감지 래퍼를 사용할 수 없음, @Observable을 적용 위해 이렇게 변수로 만듦
    var currentUserSession: FirebaseAuth.User?
    
    private init() {
        // 앱을 다시켤때마다 이 싱글톤이 생성될 떄 currentUserSession은 항상 nil이 되므로 생성자에서 .auth()currentUser를 가져와서 할당한다.
        currentUserSession = Auth.auth().currentUser
    }
    
    
    // 회원가입
    func createUser(email: String, password: String, name: String, username: String) async { // 여기서 async 처리하여 상위로 위임
        print("email:", email)
        print("password:", password)
        print("name:", name)
        print("username:", username)
        
        do {
            // MARK: Firebase 회원가입
            // 에러를 뱉을 수 있고, 네트워킹으로 오래걸리는 함수이므로 -> try await 사용
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // AuthDataResult를 반환함
            currentUserSession = result.user // .user로 접근하면 회원가입(로그인)한 유저에 대한 정보가 설정됨
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // 로그아웃
    func signout() {
        do {
            try Auth.auth().signOut()
            currentUserSession = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}

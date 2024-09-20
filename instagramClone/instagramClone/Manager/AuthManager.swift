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
import Firebase

@Observable // @Observable 매크로 설정
class AuthManager {
    
    static let shared = AuthManager()
    
    // Auth.auth().currentUser : 회원가입이나 로그인을 하면 currentUser에 로그인된 사용자값이 세팅된다.(이것으로 로그인이 됐는지 안됐는지 파악)
    // Auth.auth().currentUser으로 접근하는 것은 Firebase에서 제공하는 것이므로 자체로는 @State와 같은 상태감지 래퍼를 사용할 수 없음, @Observable을 적용 위해 이렇게 변수로 만듦
    var currentAuthUser: FirebaseAuth.User?
    var currentUser: User?
    
    private init() {
        // 앱을 다시켤때마다 이 싱글톤이 생성될 떄 currentUserSession은 항상 nil이 되므로 생성자에서 .auth()currentUser를 가져와서 할당한다.
        currentAuthUser = Auth.auth().currentUser
        Task {
            await loadUserData() // 유저 정보(이름, 닉네임등)를 가져옴
        }
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
            currentAuthUser = result.user // .user로 접근하면 회원가입(로그인)한 유저에 대한 정보가 설정됨
            guard let userId = currentAuthUser?.uid else { return } // Firebase에 가입된 UID(유저 분별)
            await uploadUserData(userId: userId, email: email, username: username, name: name)
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // 유저정보 업로드(유저 이름과 닉네임을 Firebase database에 저장)
    func uploadUserData(userId: String, email: String, username: String, name: String) async {
        let user = User(id: userId, email: email, username: username, name: name)
        // 회원가입시 유저정보를 업로드하는데 유저정보를 (프로퍼티)currentUser에 장착을 시켜야함
        self.currentUser = user
        do {
            // 유저 정보 인코딩
            let encodedUser = try Firestore.Encoder().encode(user)
            // 서버 업로드(users 그룹에 데이터 저장하고 document 키값은 user.id로 구분)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to upload user data with error \(error.localizedDescription)")
        }
        
    }
    
    // 로그인
    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            //Auth.auth().currentUser 여기에 로그인 정보가 담기지만 View에 반영이 되기 위해 currentUserSession 변수에 담아줌
            currentAuthUser = result.user // 로그인된 유저가 세팅됨
            await loadUserData() // 유저정보 가져옴(이름, 닉네임등)
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
        }
    }
    
    // 유저정보 로드
    // Auth에서 UID를 가져와서 Firebase Database에서 조회
    func loadUserData() async {
        guard let userId = self.currentAuthUser?.uid else { return } // uid 가져오고
        do {
            self.currentUser = try await Firestore.firestore().collection("users").document(userId).getDocument(as: User.self) // 저장된 userId기준으로 해당 유저만 가져옴(getDocument(as: Decodable.Type)으로 User타입으로 변형해서 가져옴
            print("currentUser:", currentUser)
        } catch {
            print("DEBUG: Failed to load user data with error \(error.localizedDescription)")
        }
    }
    
    // 로그아웃
    func signout() {
        do {
            try Auth.auth().signOut()
            currentAuthUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}

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
    var currentAuthUser: FirebaseAuth.User? // Firebase Auth에서 가져온 이메일에 대한 정보
    var currentUser: User? // 앱에서 만든 유저 데이터(유저네임, 네임 등 정보가 추가됨)
    
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
    
    // 유저정보 로드(현재 유저를 가져오고)
    // Auth에서 UID를 가져와서 Firebase Database에서 조회
    func loadUserData() async {
        guard let userId = self.currentAuthUser?.uid else { return } // (현재 유저 기반으로)uid 가져오고
        do {
            self.currentUser = try await Firestore.firestore().collection("users").document(userId).getDocument(as: User.self) // 저장된 userId기준으로 해당 유저만 가져옴(getDocument(as: Decodable.Type)으로 User타입으로 변형해서 가져옴 (*as없이 사용하면 그냥 딕셔너리 타입으로 가져올 수 있음)
        } catch {
            print("DEBUG: Failed to load user data with error \(error.localizedDescription)")
        }
    }
    
    // (오버로딩)유저정보 로드(해당 유저를 가져오고)
    // userId 인자로 받아 uid기준으로 유저데이터를 로드(post작성된 user의 uid를 매칭하기 위해)
    func loadUserData(userId: String) async -> User? {
        do {
            let user = try await Firestore.firestore().collection("users").document(userId).getDocument(as: User.self)
            return user
        } catch {
            print("DEBUG: Failed to load user data with error \(error.localizedDescription)")
            return nil
        }
    }
    
    // 로그아웃
    func signout() {
        do {
            try Auth.auth().signOut()
            currentAuthUser = nil
            currentUser = nil // 로그아웃 후 기존 유저정보 삭제를 위해 currentUser까지
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}

// (조금 다른 내용)구분위해 확장
extension AuthManager {
    
    // (팔로우)팔로잉 할 대상 id가 인자로 들어와야 함
    func follow(userId: String) async {
        // 현재 로그인 되어있는 id 가져오고
        guard let currentUserId = currentUser?.id else { return }
        
        do {
            // MARK: async let
            // (asnyc let 사용전에는)'following하는' await 작업이 먼저 끝나야 'follow 받는' await 함수가 (순차대로)실행되는데 async let _(리턴값이 없으므로 언더스코어 사용)을 사용하면 각각 (동시에)병렬적으로 비동기 실행이 된다.(결과는 나중에 받음)
            // 두 작업이 순서가 필요없고 어떤 것이든 먼저 처리되도 상관없음
            
            // following 하는
            async let _ = try await Firestore.firestore()
                .collection("following") //following 컬렉션 만들고
                .document(currentUserId) // 팔로잉이니까 로그인되어 있는 (Me)userId가 팔로잉할 대상을 적어줄 것(그래서 여기(document)는 현재 나의 userId가 입력되도록)
                .collection("user-following") // 컬렉션을 추가로 만듦
                .document(userId) // 누굴 팔로잉 하고 있는지 상대방 userId를 여기에 적을 것(인자로 받은 userId)
                .setData([:]) // id만 있으면 되니 빈데이터 넣어줌
            
            // follow 받는
            async let _ = try await Firestore.firestore()
                .collection("follower")
                .document(userId) // 인자로 들어온 userID가 팔로우 받고 있다는 것을 저장
                .collection("user-follower")
                .document(currentUserId) // (누구한테 팔로우 받고 있는지) (Me)userId한테 팔로우 받고 있다.
                .setData([:])
        } catch {
            print("DEBUG: Failed to save follow data with error \(error.localizedDescription)")
        }
    }
    
    // 언팔로우
    func unfollow(userId: String) async {
        // 현재 로그인 되어있는 id 가져오고
        guard let currentUserId = currentUser?.id else { return }
        
        do {
            // Firestore DB 접근하는 것까지는 팔로우와 동일하고 setData 대신 delete 해주면 됨
            async let _ = try await Firestore.firestore()
                .collection("following")
                .document(currentUserId)
                .collection("user-following")
                .document(userId)
                .delete() // setData 대신 delete
            
            async let _ = try await Firestore.firestore()
                .collection("follower")
                .document(userId)
                .collection("user-follower")
                .document(currentUserId)
                .delete()
        } catch {
            print("DEBUG: Failed to delete follow data with error \(error.localizedDescription)")
        }
    }
    
    // 현재 id가 상대방 id를 팔로우 하고 있는지 안하는지 체크
    func checkFollow(userId: String) async -> Bool {
        guard let currentUserId = currentUser?.id else { return false }
        
        do {
            // Firestore DB에 접속해서 확인
            let isFollowing = try await Firestore.firestore()
                .collection("following")
                .document(currentUserId)
                .collection("user-following")
                .document(userId)
                .getDocument() // document를 가져오고(팔로우가 되었다면 해당 userId를 getDocumnet 가능하니까?
                .exists // Bool 반환해줌(getDocumnet가 있는지 없는지 알려줌) -> 최종적으로 isFollowing 결과값이 변수에 담김
            return isFollowing
        } catch {
            print("DEBUG: Failed to follow data with error \(error.localizedDescription)")
            return false
        }
    }
}

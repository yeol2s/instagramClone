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
import Firebase

@Observable
class ProfileViewModel {
    var user: User? // user 내부는 감지가 불가능함(모델이고 내부에 @State와 같은 선언이 안되어있으므로)
    
    // 프로필편집뷰(ProfileEditingView)에서 텍스트필드에서 바인딩(감지 가능하도록)이 될 수 있도록 감지 가능한 프로퍼티들(currentUser에서 빼내와서 초기화)
    // 추가로 프로필뷰에서도 기존에는 user(User) 프로퍼티로 접근했었는데 빼내진 프로퍼티로 접근하도록 변경함
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
    
    // 프로필을 편집하고 뒤로가기 할 때 데이터 저장될 수 있게
    // (바인딩을 위해 user에서 꺼내왔으니)일단 user에 저장시키고 그 다음 서버에 올려야함
    func updateUser() async {
        // 입력을 다하고 뒤로가기 눌렀을 때 서버에 저장이 안되는 경우 로컬에 있는 유저값도 변경되면 안되므로 (순서를)서버에 저장을 먼저하도록 함
        do {
            try await updateUserRemote() // 서버 저장(에러 발생시 catch로 넘어가고, 오래걸려도 await으로 반환타입을 받을때까지 기다리므로 로컬 저장은 그때까지 호출되지 않음)
            updateUserLocal() // 로컬 저장
        } catch {
            print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
        }
    }
    
    // (프로필 편집)로컬에 저장
    func updateUserLocal() {
        // 변동(수정)이 없거나 비어있을 때는 저장이 되지않도록
        // swift 문법에서는 && 연산자를 ,(쉼표)로 대신할 수 있다.
        if name != "", name != user?.name { // 쉼표(,)로 && 연산자 대체
            user?.name = name
        }
        if username.isEmpty == false, username != user?.username {
            user?.username = username
        }
        if !bio.isEmpty, bio != user?.bio {
            user?.bio = bio
        }
    }
    
    func updateUserRemote() async throws { // async, throws 상위로 올림
        var editedData: [String: Any] = [:]
        
        if name != "", name != user?.name { // 쉼표(,)로 && 연산자 대체
//            user?.name = name
            editedData["name"] = name
        }
        if username.isEmpty == false, username != user?.username {
//            user?.username = username
            editedData["username"] = username
        }
        if !bio.isEmpty, bio != user?.bio {
//            user?.bio = bio
            editedData["bio"] = bio
        }
        
        // editeData가 비어있지 않고 UID가 바인딩 성공했을때만 서버에 올림
        if !editedData.isEmpty, let userId = user?.id {
            try await Firestore.firestore().collection("users").document(userId).updateData(editedData) // UID로 저장된 documnet를 가져옴(해당 아이디의 정보로 접근할 수 있게됨) 그리고 updateData를 통해 editedData를 넣어주면 변경된 정보가 딕셔너리 형태로 전달되어 Firestore Database에 적용됨(수정된 것만 반영되어 업데이트)
            
        }
    }
    
}

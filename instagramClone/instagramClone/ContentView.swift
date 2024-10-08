//
//  ContentView.swift
//  instagramClone
//
//  Created by 유성열 on 9/1/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var signupViewModel = SignupViewModel() // (회원가입)뷰모델
    
    var body: some View {
        
        // MARK: 로그인 여부에 따라서 로그인창 띄울지 여부
        // (현재 유저 상태 확인)회원가입이 완료되면 로그인되고 메인화면으로 넘어갈 수 있도록
        // MARK: (Old-1)
        //if AuthManager.shared.currentAuthUser != nil { // 상태감지(AuthManager은 @Observable 매크로 설정)
        
        // MARK: (이것도 Old-2)currentAuthUser를 기준으로 조건문을 걸면 로그아웃 후 (간헐적 발생)다른 계정으로 회원가입 후 로그인을 하면 프로필 뷰에서 데이터를 못가져오는 경우가 발생한다. 이유는 AuthManager에서 회원가입시 Firebase 서버로 데이터를 넘기는 와중에(currentAuthUser가 세팅된 후 uploadUserData를 통해 currentUser(여기서 유저 정보등이 전달되어 저장됨)가 세팅되므로 currentAuthUser는 이미 로그인이 된 것으로 판단하여 프로필에 접근하면 데이터를 못가져온다. 그래서 로그인을 확인하는 시점인 이 부분에서 실제 유저가 세팅된 currentUser를 기준으로 뷰가 변경되도록 해야함 (*근데 문제가 로그인이 되어있어도 로그인뷰가 먼저 살짝뜨게되는 문제가 발생함. 딜레이 문제로)
        //        if AuthManager.shared.currentUser != nil {
        //            MainTabView() // 로그인 되었다면 메인뷰로
        //        } else {
        //            LoginView()
        //            // 뷰모델을 environment(환경에 넣어주는 것 - 꺼내서 쓸 수 있음) 간접적으로 넣어주는 것
        //            // 다음 뷰들이 뷰모델을 쓰고 싶으면 꺼내서 쓰고, 안쓰고 싶으면 안 쓸수 있는 것
        //                .environment(signupViewModel) // .environment(_ object:)
        //        }
        
        // MARK: (New)개선된 내용
        if AuthManager.shared.currentUser == nil {
            LoginView()
            // 뷰모델을 environment(환경에 넣어주는 것 - 꺼내서 쓸 수 있음) 간접적으로 넣어주는 것
            // 다음 뷰들이 뷰모델을 쓰고 싶으면 꺼내서 쓰고, 안쓰고 싶으면 안 쓸수 있는 것
                .environment(signupViewModel) // .environment(_ object:)
        } else {
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}

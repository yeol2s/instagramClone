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
        if AuthManager.shared.currentUserSession != nil { // 상태감지(AuthManager은 @Observable 매크로 설정)
            MainTabView() // 로그인 되었다면 메인뷰로
        } else {
            LoginView()
            // 뷰모델을 environment(환경에 넣어주는 것 - 꺼내서 쓸 수 있음) 간접적으로 넣어주는 것
            // 다음 뷰들이 뷰모델을 쓰고 싶으면 꺼내서 쓰고, 안쓰고 싶으면 안 쓸수 있는 것
                .environment(signupViewModel) // .environment(_ object:)
        }
    }
}

#Preview {
    ContentView()
}

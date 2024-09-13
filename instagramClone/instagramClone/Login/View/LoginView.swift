//
//  LoginView.swift
//  instagramClone
//
//  Created by 유성열 on 9/8/24.
//
// MARK: - LoginView

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        NavigationStack {
            ZStack { // 그라디언트뷰 위에 뷰 레이아웃 구성위해 ZStack
                GradientBackgroundView() // 그라디언트뷰
                
                VStack {
                    Spacer()
                    Image("instagramLogo")
                        .resizable()
                        .frame(width: 57, height: 57) // 사이즈 고정(실제 앱 사이즈와 최대한 맞춤)
                    Spacer()
                    
                    VStack(spacing: 20) {
                        TextField("이메일 주소", text: .constant("")) // .constant는 임시바인딩값 주기위함
                            .modifier(InstagramTextFieldModifier()) // 뷰모디파이어 가져옴
                        
                        SecureField("비밀번호", text: .constant("")) // 비밀번호(****)
                            .modifier(InstagramTextFieldModifier())
        
                        
                        // MARK: New(ViewBuilder(View + Action)
                        BlueButtonView { // ViewBuilder(view + action 인자)
                            print("로그인 되었습니다.")
                        } label: {
                            Text("로그인")
                        }
                        
                        Text("비밀번호를 잊으셨나요?")
                    } //:VSTACK
                    
                    Spacer()
                    
                    NavigationLink {
                        EnterEmailView() // (이동)새 계정 만들기 뷰
                    } label: {
                        Text("새 계정 만들기")
                            .fontWeight(.bold)
                            .frame(width: 363, height: 42)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.blue, lineWidth: 1)
                            }
                    } //:NAVIGATION LINK
                } //:VSTACK
            } //:ZSTACK
        } //:NAVIGATION
    }
}

#Preview {
    LoginView()
}

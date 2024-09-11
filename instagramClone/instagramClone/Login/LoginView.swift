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
                            .textInputAutocapitalization(.never) // 첫글자가 대문자로 설정되는걸 방지(소문자를 강제하게)
                            .padding(12)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // clipShape: 뷰의 경계를 특정모양으로 자름
                            .overlay { // overlay: 인수로 전달된 뷰를 원래 뷰 위에 덧붙임 (.stroke를 통해 gray 테두리 그리는 것)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1) // stroke: 주어진 두께로 도형의 외곽선 그리기
                            }
                            .padding(.horizontal)
                        
                        SecureField("비밀번호", text: .constant("")) // 비밀번호(****)
                            .textInputAutocapitalization(.never)
                            .padding(12)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .padding(.horizontal)
                        
                        Button {
                            print("로그인 되었습니다.")
                        } label: {
                            Text("로그인")
                                .foregroundStyle(.white)
                                .frame(width: 363, height: 42)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
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

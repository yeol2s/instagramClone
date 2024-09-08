//
//  LoginView.swift
//  instagramClone
//
//  Created by 유성열 on 9/8/24.
//
// MARK: - LoginView

import SwiftUI

struct LoginView: View {
    // (그라디언트 사용) 실제 인스타그램 앱 백그라운드 컬러 추출한 것
    // RGB 0~255 단위를 255로 나눈 값(0~1사이) (굳이 이렇게 0~1 단위로 입력하지 않아도 인자값으로 바로 255 나눠버려도 됨)
    // ex) let yellowColor = Color(red: 255/255, green: 249/255, blue: 241/255)
    let yellowColor = Color(red: 0.9960784314, green: 0.9764705882, blue: 0.9529411765)
    let redColor = Color(red: 0.9921568627, green: 0.9490196078, blue: 0.9725490196)
    let blueColor = Color(red: 0.9333333, green: 0.968627451, blue: 0.9960784314)
    let greenColor = Color(red: 0.937254902, green: 0.9882352941, blue: 0.9529411765)
    
    var body: some View {
        ZStack { // 그라디언트 위에 뷰 레이아웃 구성위해 ZStack
            // (기본)그라디언트 설정(블루(탑에서 시작)->레드(바텀))
            //        LinearGradient(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom)
            // (정밀)그라디언트 설정(Stop(location: 값)으로 색이 섞이지 않는 영역을 지정할 수 있음)
            LinearGradient(stops: [
                Gradient.Stop(color: yellowColor, location: 0.1),
                Gradient.Stop(color: redColor, location: 0.3),
                Gradient.Stop(color: blueColor, location: 0.6),
                Gradient.Stop(color: greenColor, location: 1)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea() // safeArea영역까지 그라디언트 설정
            
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
                
                Button {
                    print("새 계정 만들기")
                } label: {
                    Text("새 계정 만들기")
                        .fontWeight(.bold)
                        .frame(width: 363, height: 42)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.blue, lineWidth: 1)
                        }
                }
            } //:VSTACK
        } //:ZSTACK
    }
}

#Preview {
    LoginView()
}

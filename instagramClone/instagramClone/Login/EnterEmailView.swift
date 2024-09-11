//
//  EnterEmailView.swift
//  instagramClone
//
//  Created by 유성열 on 9/11/24.
//
// MARK: - (회원가입)이메일 주소 입력 View

import SwiftUI

struct EnterEmailView: View {
    
    // 네비게이션스택 Back 버튼 구현위해 환경변수에서 뒤로가는 정보를 가져와야함(@Environment)
    // dismiss라는 곳에 저장되어있음(환경 변수에게 dismiss는 내가 관리할 수 있도록 변수에 담는 것)
    // 네비게이션스택 자체에 pop 기능이 있지만 여기서는 Button을 커스텀하여 만들었으므로 dismiss 구현
    @Environment(\.dismiss) var dismiss // 이렇게 하면 dismiss를 사용 가능
    
    var body: some View {
        ZStack {
            GradientBackgroundView() // 그라디언트 뷰
            VStack {
                Text("이메일 주소 입력")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                Text("회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 이메일 주소는 프로필에서 다른 사람에게 공개되지 않습니다.")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
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
                
                NavigationLink {
                    EnterPasswordView() // (다음 화면)회원 가입 패스워드 입력뷰
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                        .frame(width: 363, height: 42)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } //:NAVIGATION LINK
                Spacer()
            } //:VSTACK
        } //:ZSTACK
        .navigationBarBackButtonHidden() // 기존에 있는 네비게이션 BackButton 삭제
        .toolbar { // 새로운 툴바 생성(네비게이션 관련)
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss() // 현재 화면 종료
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
    }
}

#Preview {
    EnterEmailView()
}

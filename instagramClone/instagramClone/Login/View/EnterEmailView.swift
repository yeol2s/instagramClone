//
//  EnterEmailView.swift
//  instagramClone
//
//  Created by 유성열 on 9/11/24.
//
// MARK: - (회원가입)이메일 주소 입력 View

import SwiftUI

struct EnterEmailView: View {
    // MARK: 1. Environmnet(환경)에 들어간 뷰모델을 꺼내쓴다.
    // 환경에 들어있는 뷰모델을 변수에 받아서 사용하겠다.
    // 읽기만 한다면 이렇게만 선언해서 사용해도 되는데 데이터를 변경하는 경우에는 @Bindable을 사용해야함
    @Environment(SignupViewModel.self) var signupViewModel
    
    var body: some View {
        // MARK: 2. @Bindable 사용
        // 뷰모델이 다시 여기에 바인딩을 시켜서 사용해야함(읽기/쓰기 모두 사용하려면)
        @Bindable var signupViewModel = signupViewModel
        
        // ViewBuilder 사용(마치 VStack, ZStack 처럼 content를 받아 View를 반환하는 역할이 됨(VStack, ZStack도 뷰빌더 구조인 것)
        // SignupBackgroundView(content: <#T##() -> View#>)
        // ZStack(content: () -> View)
        // MARK: ViewBuilder
        SignupBackgroundView {
            // MARK: 뷰빌더에 GradientBackground + Custom BackButton이 적용된 상태고 그 안에 VStack으로 구현된 뷰를 인자값으로 넣어주는 것(백그라운드+백버튼은 재사용이 되는 것)
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
                
                TextField("이메일 주소", text: $signupViewModel.email)
                    .modifier(InstagramTextFieldModifier())
                
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
        } //:ViewBuilder
    }
}

#Preview {
    EnterEmailView()
}

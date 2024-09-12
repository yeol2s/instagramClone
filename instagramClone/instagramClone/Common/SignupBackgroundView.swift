//
//  SignupBackgroundView.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - Login(그라디언트만), 회원가입(그라디언트뷰+네비게이션바백버튼)뷰들 ViewBuilder
// 공통된 특징을 가지고 있는 뷰를 통일 시키기 위해 특정 기준으로 컴포넌트화 하는 것(재사용 가능한 뷰)

import SwiftUI

struct SignupBackgroundView<Content: View>: View {
    
    // 네비게이션스택 Back 버튼 구현위해 환경변수에서 뒤로가는 정보를 가져와야함(@Environment)
    // dismiss라는 곳에 저장되어있음(환경 변수에게 dismiss는 내가 관리할 수 있도록 변수에 담는 것)
    // 네비게이션스택 자체에 pop 기능이 있지만 여기서는 Button을 커스텀하여 만들었으므로 dismiss 구현
    @Environment(\.dismiss) var dismiss // 이렇게 하면 dismiss를 사용 가능
    
    let content: Content
    
    // 생성자 파라미터에 ViewBuilder 선언
    // ViewBuilder가 사용된 클로저 안에서는 여러개의 뷰를 받아서 반환할 수 있음(여러 뷰를 하나의 View로 결합하여 반환 - 하나의 뷰로 묶음)
    init(@ViewBuilder content: () -> Content) { // 생성자에서는 content()로 전달된 클로저를 실행하고 -> 뷰빌더는 여러 뷰를 하나의 Content로 결합하여 반환
        self.content = content()
    }
    
    // MARK: content 외부의 것들이 결국에 재사용이 가능해지는 것(ZStack + GradientBackground + Button(dismiss))
    var body: some View {
        ZStack {
            GradientBackgroundView() // 그라디언트 뷰
            content // content에는 인자값으로 받은 뷰(예제에서는 VStack 내용들)가 들어올 것
        }//:ZSTACK
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

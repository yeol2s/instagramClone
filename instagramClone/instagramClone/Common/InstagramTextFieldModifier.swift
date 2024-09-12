//
//  InstagramTextFieldModifier.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - 텍스트필드 ViewModifier
// 이메일, 패스워드 처럼 공통적인 부분에서 설정된 Modifier 설정 코드 중복을 줄여주기 위함
// 뷰 모디파이어를 커스텀해서 컴포넌트화

import SwiftUI

struct InstagramTextFieldModifier: ViewModifier {
    
    // MARK: 이 함수는 인자로 Content를 받는다. Content에 내가 원하는 Modifier를 붙여서 리턴하는 것(content는 호출(.modifier())한 View가 들어온다.)
    func body(content: Content) -> some View {
        content // content 밑으로 원하는 Modifier를 넣어주면 됨
            .textInputAutocapitalization(.never) // 첫글자가 대문자로 설정되는걸 방지(소문자를 강제하게)
            .padding(12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10)) // clipShape: 뷰의 경계를 특정모양으로 자름
            .overlay { // overlay: 인수로 전달된 뷰를 원래 뷰 위에 덧붙임 (.stroke를 통해 gray 테두리 그리는 것)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1) // stroke: 주어진 두께로 도형의 외곽선 그리기
            }
            .padding(.horizontal)
    }
}


//
//  EnterNameView.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - (회원가입)이름 입력 View

import SwiftUI

struct EnterNameView: View {
    
    var body: some View {
        SignupBackgroundView {
            VStack {
                Text("이름 입력")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                TextField("성명", text: .constant(""))
                    .modifier(InstagramTextFieldModifier())
                
                NavigationLink {
                    EnterUserNameView() // (다음 화면)회원가입 사용자 이름 입력 뷰
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                        .frame(width: 363, height: 42)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Spacer()
            } //:VSTACK
        } //:ViewBuilder
    }
}

#Preview {
    EnterNameView()
}

//
//  EnterUserNameView.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - (회원가입)사용자 이름 만들기 View


import SwiftUI

struct EnterUserNameView: View {

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GradientBackgroundView() // 그라디언트 뷰
            VStack {
                Text("사용자 이름 만들기")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                Text("사용자 이름을 직접 추가하거나 추천 이름을 사용하세요. 언제든지 변경할 수 있습니다.")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                TextField("사용자 이름", text: .constant(""))
                    .textInputAutocapitalization(.never)
                    .padding(12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    }
                    .padding(.horizontal)
                
                NavigationLink {
                    CompleteSignupView() // (다음 화면)회원가입 완료 Welcome View
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                        .frame(width: 363, height: 42)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Spacer()
            } //:VSTACK
        } //:ZSTACK
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
    }
}

#Preview {
    EnterUserNameView()
}

//
//  EnterNameView.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - (회원가입)이름 입력 View

import SwiftUI

struct EnterNameView: View {

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GradientBackgroundView() // 그라디언트 뷰
            VStack {
                Text("이름 입력")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                TextField("성명", text: .constant(""))
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
    EnterNameView()
}

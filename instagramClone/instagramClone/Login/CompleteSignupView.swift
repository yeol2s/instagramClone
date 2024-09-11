//
//  CompleteSignupView.swift
//  instagramClone
//
//  Created by 유성열 on 9/12/24.
//
// MARK: - (회원가입) 가입 완료 Welcome View

import SwiftUI

struct CompleteSignupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Image("instagramLogo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 172, height: 172)
                    .foregroundStyle(Color.gray)
                    .opacity(0.5) // 연한 그레이를 연출하기 위해 투명도 조절
                    .overlay {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2) // 테두리만 나오게
                            .opacity(0.5)
                            .frame(width: 185, height: 185) // Circle에 frame을 더 크게 주는 이유는 stroke로 만들어진 테두리와 이미지 사이에 빈공간 느낌을 주기 위함
                    }
                
                // 임시 텍스트
                Text("열님, Instagram에 오신 것을 환영합니다.")
                    .font(.title)
                    .padding(.top, 30)
                    .padding(.horizontal)
                Spacer()
                
                Button {
                    print("완료")
                } label: {
                    Text("완료")
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
    CompleteSignupView()
}

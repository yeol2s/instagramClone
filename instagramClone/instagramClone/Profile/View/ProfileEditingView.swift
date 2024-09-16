//
//  ProfileEditingView.swift
//  instagramClone
//
//  Created by 유성열 on 9/17/24.
//
// MARK: - ProfileEditingView(프로필 편집)
// MARK: PhotosPicker 사용

import SwiftUI

struct ProfileEditingView: View {
    
    // 네비게이션백버튼 커스텀위해 환경값에서 dismiss 가져옴
    @Environment(\.dismiss) var dismiss
    // 프로필뷰와 여기서 표시할 데이터가 동일하므로 같은 뷰모델 전달받음
    @Bindable var viewModel: ProfileViewModel // 상위뷰 뷰모델 전달받음
    
    var body: some View {
        VStack {
            Image("profile_cat")
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .padding(.bottom, 10)
            Text("사진 또는 아바타 수정")
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 5) {
                Text("이름")
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                //                TextField("이름", text: .constant("고양이 대장군"))
                TextField("이름", text: $viewModel.name)
                    .font(.title2)
                Divider()
            } //:VSTACK
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("사용자 이름")
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                //                TextField("사용자 이름", text: .constant("general.cat"))
                TextField("사용자 이름", text: $viewModel.username)
                    .font(.title2)
                Divider()
            } //:VSTACK
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("소개")
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
//                TextField("소개", text: .constant("세계를 정복한다."))
                TextField("소개", text: $viewModel.bio)
                    .font(.title2)
                Divider()
            } //:VSTACK
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
        } //:VSTACK
        .navigationTitle("프로필 편집")
        .navigationBarBackButtonHidden() // 기존 네비게이션백버튼 숨기기
        .toolbar { // 커스텀 백버튼 만듦
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .tint(.black)
                }
            }
        }
    }
}

#Preview {
    ProfileEditingView(viewModel: ProfileViewModel())
}

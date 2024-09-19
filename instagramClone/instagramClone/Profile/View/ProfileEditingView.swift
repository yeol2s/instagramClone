//
//  ProfileEditingView.swift
//  instagramClone
//
//  Created by 유성열 on 9/17/24.
//
// MARK: - ProfileEditingView(프로필 편집)
// MARK: PhotosPicker 사용

import SwiftUI
import PhotosUI

struct ProfileEditingView: View {
    
    // 네비게이션백버튼 커스텀위해 환경값에서 dismiss 가져옴
    @Environment(\.dismiss) var dismiss
    // 프로필뷰와 여기서 표시할 데이터가 동일하므로 같은 뷰모델 전달받음
    @Bindable var viewModel: ProfileViewModel // 상위뷰 뷰모델 전달받음
    
    var body: some View {
        VStack {
            // 이미지를 PhotosPicker로 감싸줌(selection: 선택한 사진이 저장될 바인딩변수)
            PhotosPicker(selection: $viewModel.selectedItem) {
                VStack {
                    // 사진 선택시 화면에 반영되도록(profileImage로 view에서 사용)
                    if let profileImage = viewModel.profileImage {
                        profileImage // Image View
                            .resizable()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .padding(.bottom, 10)
                    } else { // 사진을 선택하지 않아서 이미지가 없으면
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                        //1. opacity 같이 주는 방법
//                            .foregroundStyle(Color.gray.opacity(0.5))
                        //2.
//                            .foregroundStyle(Color.gray)
//                            .opacity(0.5)
                        //3. UIKit CGColor 형식(.systemGray 1~5 단계별로 톤이 다름)
                            .foregroundStyle(Color(.systemGray3))
                            .clipShape(Circle())
                            .padding(.bottom, 10)
                    }
                    Text("사진 또는 아바타 수정")
                        .foregroundStyle(.blue)
                } //:VSTACK
            } //:PhotosPicker
            // PhotosPicker에서 변화를 감지할 수 있도록 onChange 메서드
            // of: 감지할변수(값 변경되면 클로저 실행), 클로저 : oldValue(직전값), newValue(직후값)
            .onChange(of: viewModel.selectedItem) { oldValue, newValue in
                Task {
                    await viewModel.convertImage(item: newValue) // 이미지 장착
                }
            }
            
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
                    Task {
                        await viewModel.updateUser() // 프로필 편집 변경사항 업데이트
                        dismiss() // dismiss가 Task 내/외부 위치하느냐에 따라 동작구조가 바뀜(내부에 있으면 비동기적으로 처리되므로 서버에 업데이트가 반영되어야 dismiss가 호출되고, 외부에 있으면 업데이트와 상관없이 바로 호출)
                    }
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

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
import Kingfisher // (캐싱을 사용하는 이미지 로드)라이브러리 *AsyncImage 대용

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
                    } else if let imageUrl = viewModel.user?.profileImageUrl  { // 서버에 있는지 체크
                        // 첫번째 우선순위로는 프로필 사진 선택시 선택된 것을 가져오는 것을 우선으로 하고 선택하지 않았을때에는 서버에 있는지 체크
                        let url = URL(string: imageUrl) // URL형식으로 변경하고
                        // MARK: (New)Kingfisher 사용 (캐싱 가능한 이미지 로드 라이브러리)
                        KFImage(url) // (내부적으로 캐싱이 구현되어있음)URL을 판별하여 이미 접근한 이미지인 경우 비동기적으로 캐시에서 저장된 데이터 이미지를 가져옴
                            .resizable()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .padding(.bottom, 10)
                        
                        // MARK: (Old)AsyncImage는 따로 캐싱(임시저장)을 못하고 계속해서 이미지를 불러온다.(편집 뷰에 진입할때마다 계속 이미지를 불러오고 로딩을 발생시키므로 캐싱을 따로 구현해줘야 한다. -> 직접 구현에는 번거로움이 있으므로 라이브러리 사용)
//                        AsyncImage(url: url) { image in // AsyncImage: URL로 이미지를 가져오는 뷰
//                            image
//                                .resizable()
//                                .frame(width: 75, height: 75)
//                                .clipShape(Circle())
//                                .padding(.bottom, 10)
//                        } placeholder: { // 이미지가 가지고 올동안(로딩시간동안)보여줘야 할 임시이미지
//                            ProgressView() // 로딩뷰
//                        }
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

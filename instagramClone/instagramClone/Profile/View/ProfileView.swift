//
//  ProfileView.swift
//  instagramClone
//
//  Created by 유성열 on 9/16/24.
//
// MARK: - ProfileView(프로필뷰)
import SwiftUI

struct ProfileView: View {
    @State var viewModel = ProfileViewModel() // 프로필뷰모델
    
    // Grid 설정정보(Columns) - 열을 어떻게 만들지(몇개의 열, 어떤방식)
    let columns: [GridItem] = [
        // GirdItem을 생성하면 인자들을 받는데 GridItem에 어떤 타입의 열을 넣을 것인지 알려주는 것
        /*
         첫번째 인자
         .fixed: 열의 크기를 고정(아이폰 화면 유무 관계없이 크기가 고정되므로 어떤 화면에서는 작고, 어떤 화면에서는 삐져나오는 문제가 발생할 수 있음) - 크기가 고정
         .flexible: (개선된 버전)화면에 원하는 만큼 꽉 채울 수 있음(화면에 맞춰 반영) - (화면에 맞추지만)열 개수 고정
         .adaptive: 위 f들은 생성한 만큼 열이 고정되어있는데 이녀석은 넣을 수 있을 만큼 다 넣음(화면에 맞게끔) - (화면에 맞추지만)열 개수 고정되어있지 않음
         
         *보통은 fixed, flexible을 많이 사용
         
         두번째 인자(spacing) : 열 간격
         */
        // min, max를 사용하면 상,하한선을 정할 수 있고 비우면 최대한 꽉 채움
        // 이렇게 3개를 넣으면 3개가 들어가는 한해서 꽉 채움
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2) // 마지막은 spacing 생략가능
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(viewModel.user?.username ?? "")")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .opacity(0.6)
                        VStack {
                            Text("124")
                                .fontWeight(.semibold)
                            Text("게시물")
                        } //:VSTACK
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("999")
                                .fontWeight(.semibold)
                            Text("팔로워")
                        } //:VSTACK
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("1403")
                                .fontWeight(.semibold)
                            Text("팔로잉")
                        } //:VSTACK
                        .frame(maxWidth: .infinity) // 균등하게 최대한 공간을 차지하도록 VStack 각각 maxinfinity
                    } //:HSTACK
                    .padding(.horizontal)
                    
                    // 이름과 소개글
                    Text("\(viewModel.user?.name ?? "")")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Text("\(viewModel.user?.bio ?? "")")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    NavigationLink {
                        ProfileEditingView(viewModel: viewModel) // 프로필편집뷰
                    } label: {
                        Text("프로필 편집")
                            .bold() // fontWeight(.bold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                            .background(Color.gray.opacity(0.2)) // opacity 같이줄 수 있음
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    Divider()
                        .padding()
                    
                    // LazyVGird는 스크롤시 필요한 이미지를 불러와서 메모리 관리
                    // columns는 GridItem을 설정하여 넣어줌(Grid 방식을 설정)
                    // spacing으로 세로 간격 설정(열 간격은 GridItem 설정)
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<10) { _ in
                            Image("image_dog")
                                .resizable()
                                .scaledToFit()
                            Image("image_dragon")
                                .resizable()
                                .scaledToFit()
                            Image("image_lion")
                                .resizable()
                                .scaledToFit()
                            Image("image_penguin")
                                .resizable()
                                .scaledToFit()
                            Image("profile_cat")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    Spacer()
                } //:VSTACK
            } //:SCROLL
        } //:NAVIGATION
    }
}

#Preview {
    ProfileView()
}

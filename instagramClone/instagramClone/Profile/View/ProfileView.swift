//
//  ProfileView.swift
//  instagramClone
//
//  Created by 유성열 on 9/16/24.
//
// MARK: - ProfileView(프로필뷰)
import SwiftUI
import Kingfisher // (캐싱을 사용하는 이미지 로드)라이브러리 *AsyncImage 대용

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
                    Text("\(viewModel.username)")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    HStack {
                        // 프로필 이미지 반영
                        if let profileImage = viewModel.profileImage {
                            profileImage // Image View
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .padding(.bottom, 10)
                        } else if let imageUrl = viewModel.user?.profileImageUrl  { // 서버에 있는지 체크
                            // 첫번째 우선순위로는 프로필 사진 선택시 선택된 것을 가져오는 것을 우선으로 하고 선택하지 않았을때에는 서버에 있는지 체크
                            let url = URL(string: imageUrl) // URL형식으로 변경하고
                            // MARK: Kingfisher 사용 (캐싱 가능한 이미지 로드 라이브러리)
                            KFImage(url) // (내부적으로 캐싱이 구현되어있음)URL을 판별하여 이미 접근한 이미지인 경우 비동기적으로 캐시에서 저장된 데이터 이미지를 가져옴
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .padding(.bottom, 10)
                            
                        } else { // 사진을 선택하지 않아서 이미지가 없으면
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .clipShape(Circle())
                                .padding(.bottom, 10)
                        }
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
                    Text("\(viewModel.name)")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Text("\(viewModel.bio)")
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
                        // .task에서 loadUserPosts가 호출되면 뷰모델에 posts에 post 데이터가 쌓이므로 그걸 가져와 씀
                        ForEach(viewModel.posts) { post in
                            let url = URL(string: post.imageUrl) // 이미지가 저장되어 있는 url을 가져오고
                            KFImage(url) // 킹피셔 라이브러리(캐싱가능한 이미지 로드)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill) // .scaledToFill()로 하면 (세로가 더 긴)특정 이미지는 비율이 안맞는 문제 발생
                        }
                    }
                    // 비동기 처리를 위해 .task (View의 생명주기에 맞춰 비동기작업 실행)
                    .task {
                        await viewModel.loadUserPosts() // Post를 불러옴
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

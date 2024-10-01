//
//  SearchView.swift
//  instagramClone
//
//  Created by 유성열 on 9/30/24.
//
// MARK: - SearchView(유저 검색뷰)

import SwiftUI
import Kingfisher

struct SearchView: View {
    
    @State var viewModel = SearchViewModel()
    @State var searchText = ""
    
    // 검색어를 입력하면 searchText에 입력이 되고, 입력내용을 기반으로 viewModel.users를 건드려서 filteredUsers에 저장이 되고, 이것을 기반으로 List를 그림
    // 계산속성을 사용해서 viewModel.users로 뷰를 그리는 것이 아닌 필터링된 변수로 그려낼 것
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users // 검색한 것이 없으면 뷰모델에 있는 유저 다보여줌
        } else { // 검색한 것이 있으면
            return viewModel.users.filter { user in
                user.username.lowercased().contains(searchText.lowercased()) // filter { $0.username.contaions(searchText) }
                // .lowercased로 전부 소문자로 변경(검색시 대소문자 구분이되므로)
            }
        }
    }
    
    var body: some View {
        // MARK: LazyVStack은 사용해봤으니 List로 구현해봄
        // 검색한다는 것은 대상을 클릭해서 화면이 이동되는 것이므로 NavigationStack과 같이 사용해야함(searchable)
        NavigationStack {
            /*
             (Old)이렇게 해도되고
             List {
             ForEach(viewModel.users) { user in
             Text(user.username)
             }
             }
             */
            //(New) ForEach 대신 바로 List로 루프를 돌릴 수 있다.(똑같은 코드임)
            List(filteredUsers) { user in
                NavigationLink {
                    // ProfileViewModel user를 인자로넣어 생성
                    ProfileView(viewModel: ProfileViewModel(user: user))
                } label: {
                    HStack {
                        if let imageUrl = user.profileImageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 53, height: 53)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 53, height: 53)
                                .opacity(0.5)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(user.username)
                            Text(user.bio ?? "")
                                .foregroundStyle(.gray)
                        } //:VSTACK
                    } //:HSTACK
                } //:NAVIGATION LINK
                .listRowSeparator(.hidden) // List 라인 숨기기
            } //:LIST
            .listStyle(.plain) // List 스타일 설정(가장 기본적으로 plain)
            .searchable(text: $searchText, prompt: "검색") // 검색창(prompot: 플레이스홀더)
        } //:NAVIGATION
    }
}

#Preview {
    SearchView()
}

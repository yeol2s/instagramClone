//
//  NewPost.swift
//  instagramClone
//
//  Created by 유성열 on 9/2/24.
//

import SwiftUI

struct NewPostView: View {
    
    @State var caption = ""
    // NewPostView에서 뒤로가기를 하면 TabView의 tabIndex를 0으로 변경해서 홈 화면으로 바로 이동하기 위한 변수(바인딩)
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
            HStack {
                // 여기서 뒤로가기 버튼은 네비게이션 스택이 아닌 첫번째 탭뷰(홈)로 이동하는 버튼으로 구현
                Button {
                    tabIndex = 0 // tabIndex를 변경해서 -> tag(0) 탭뷰로 이동
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black) // tint는 '강조 컬러'
                }
                Spacer()
                Text("새 게시물")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            } //:HSTACK
            .padding(.horizontal)
            
            Image("image_lion")
                .resizable()
            // frame(maxWidth: .infinity)를 함으로써 이미지가 좌,우 를 최대한 차지한다.
            // 높이에 대한 것을 지정하지 않으면 높이도 최대가 되는데 사진의 비율을 유지하면서 좌,우만 꽉 채우게 하고 높이는 그 비율의 유지된 만큼만 차지하게 하도록 aspectRatio을 사용(아래 파라미터에서 1은 '비율'인데 가로:세로 = 1:1 비율로 맞춰줌, .fit : 콘텐츠의 원본 비율을 유지하면서 가능한 최대 크기로 뷰 안에 맞춤)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            TextField("문구를 작성하거나 설문을 추가하세요...", text: $caption) // caption 바인딩
                .padding()
            
            Spacer()
            
            Button {
                print("사진 공유")
            } label: {
                Text("공유")
                    .frame(width: 363, height: 42)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20)) // Button 코너 둥글게
            }
            .padding()
            
        } //:VSTACK
    }
}

#Preview {
    // 프리뷰에서 tabIndex의 바인딩 값을 요구하므로 임시로 .constant 사용(.constant: 바인딩으로 변경해주는 함수)
    NewPostView(tabIndex: .constant(2))
}

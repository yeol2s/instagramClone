//
//  NewPost.swift
//  instagramClone
//
//  Created by 유성열 on 9/2/24.
//

import SwiftUI
import PhotosUI // (PhotosPicker)사진선택 기능 구현 import

struct NewPostView: View {
    
    @State var caption = ""
    // NewPostView에서 뒤로가기를 하면 TabView의 tabIndex를 0으로 변경해서 홈 화면으로 바로 이동하기 위한 변수(바인딩)
    @Binding var tabIndex: Int
    
    @State var selectedItem: PhotosPickerItem? // PhotosPicker item 저장 변수
    @State var postImage: Image? // PhotosPicker item -> 이미지로 변경하여 저장할 변수
    
    // MARK: 임시위치
    // PhotosPicker item을 이미지로 변환해주는 메서드
    func convertImage(item: PhotosPickerItem?) async {
        guard let item = item else { return }
        // MARK: Data -> Image로 바로 변환이 안되므로 Data -> UIImage -> Image로 변환
        // * 과정 : PhotosPikcerItem -> Data(바이너리) -> UIImage(UIKit) -> Image(SwiftUI)
        // 1. loadTransferable : PhotosPicker item을 Data 형식(바이너리-0,1)으로 변경
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        // 2. data를 UIKit의 UIImage로 변경
        guard let uiImage = UIImage(data: data) else { return }
        // 3. SwiftUI Image 형식으로 변경
        self.postImage = Image(uiImage: uiImage)
    }
    
    var body: some View {
        VStack {
            HStack {
                // 여기서 뒤로가기 버튼은 네비게이션 스택이 아닌 첫번째 탭뷰(홈)로 이동하는 버튼으로 구현
                Button {
                    tabIndex = 0 // tabIndex를 변경해서 -> tag(0) 탭뷰로 이동 7
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
            
            // MARK: PhotosPicker - 이미지를 클릭하면 이미지 변경이 가능하도록 PhotosPicker로 해당 이미지를 감싸줌(선택한 item(이미지)가 selection에 저장되도록 바인딩)
            PhotosPicker(selection: $selectedItem) {
                // @State postImage 변수가 상태 변경된 것을 감지해서 이쪽 View가 다시 그려진다.
                if let image = self.postImage { // PhotosPicker로 사진을 장착 후
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill) // 원본 비율 유지(fill을 함으로써 이미지가 frame을 벗어나 잘릴 수 있음)
                        .frame(maxWidth: .infinity, maxHeight: 400) // 세로크기를 제한
                        .clipped() // frame 크기를 넘어간 이미지를 잘라냄(이미지는 잘렸지만 화면에 맞게 깔끔해짐)
                    //* 이 부분 헷갈릴때는 'ETC'->'ImageFitAndFillView' 참고하자
                    
                    // MARK: old(아래 구현은 aspectRatio에 1을 설정하여 이미지 비율이 무조건 1:1(가로세로)이 됨)
                    // frame(maxWidth: .infinity)를 함으로써 이미지가 좌,우 를 최대한 차지한다.
                    // 높이에 대한 것을 지정하지 않으면 높이도 최대가 되는데 사진의 비율을 유지하면서 좌,우만 꽉 채우게 하고 높이는 그 비율의 유지된 만큼만 차지하게 하도록 aspectRatio을 사용(아래 파라미터에서 1은 '비율'인데 가로:세로 = 1:1 비율로 맞춰줌, .fit : 콘텐츠의 원본 비율을 유지하면서 가능한 최대 크기로 뷰 안에 맞춤)
//                        .aspectRatio(1, contentMode: .fit)
//                        .frame(maxWidth: .infinity)
                } else { // 장착 전
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .tint(.black) // 여기서 틴트를 넣어주지 않아도 상위뷰(MainTabView)에서 틴트(.black)을 넣으므로 하위뷰들은 틴트가 자동으로 영향을 받는다.(프리뷰에선 안보임) - 프리뷰에서 보기위해서는 해주는게 좋음
                        .padding()
                }
            }
            // PhotosPicker에서 변화를 감지할 수 있도록 onChange 메서드
            // of: 감지할변수(값 변경되면 클로저 실행), 클로저 : oldValue(직전값), newValue(직후값)
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    await convertImage(item: newValue)
                }
            }
            
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

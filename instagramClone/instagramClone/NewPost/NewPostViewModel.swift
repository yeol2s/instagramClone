//
//  NewPostViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/7/24.
//
// MARK: - (NewPost)ViewModel

import SwiftUI
import PhotosUI
import FirebaseStorage // (대용량 DB)FireBase Storage 사용

@Observable // 이 뷰모델을 감지할 수 있게(View에서 바인딩 할 수 있게)(ObservableObject 프로토콜 사용했던 것에서 업데이트됨 - Swift 5.9 부터 적용)
class NewPostViewModel {
    
    // MARK: @Observable을 사용하면 클래스 내부의 속성들에 @Published(또는 @State) 선언이 굳이 필요없음(자동으로 다 감시됨)
    var caption = ""
    var selectedItem: PhotosPickerItem? // PhotosPicker item 저장 변수
    var postImage: Image? // PhotosPicker item -> 이미지로 변경하여 저장할 변수
    var uiImage: UIImage? // 이미지 업로드를 위해 converImage 메서드에서 'data를 UIKit의 UIImage로 변경'하는 과정의 uiImage를 저장하기 위함
    
    // PhotosPicker item을 이미지로 변환해주는 메서드
    func convertImage(item: PhotosPickerItem?) async {
        guard let item = item else { return }
        // MARK: Data -> Image로 바로 변환이 안되므로 Data -> UIImage -> Image로 변환
        // * 과정 : PhotosPikcerItem -> Data(바이너리) -> UIImage(UIKit) -> Image(SwiftUI)
        // 1. loadTransferable : PhotosPicker item을 Data 형식(바이너리-0,1)으로 변경
        // 여기서 await을 비동기 처리 하지 않은 이유는 위 메서드에서 async를 사용하므로써 상위로 넘겨준 것
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        // 2. data를 UIKit의 UIImage로 변경
        guard let uiImage = UIImage(data: data) else { return }
        // 3. SwiftUI Image 형식으로 변경
        self.postImage = Image(uiImage: uiImage)
        // (uploadPost시)이미지 업로드 인자값으로 사용하기 위함
        self.uiImage = uiImage
    }
    
    // 게시글 업로드
    func uploadPost() async { // async를 한번 더 상위로 넘김(View에서 Task 처리할 것임)
        guard let uiImage else { return } // (팁) 옵셔널 바인딩할때 guard let uiImage = self.uiImage else 이렇게 할때 변수이름이 똑같다면 생략 가능함
        let url = await uploadImage(uiImage: uiImage) // url은 Firebase에서 사진을 내려받을 수 있는 주소임(이미지가 저장된 주소)
        print("url:", url)
    }
    
    // 사진 업로드(게시글을 업로드 하면서 여러가지 정보중에 (게시글 내부에서)사진이 같이 업로드되는 것)
    func uploadImage(uiImage: UIImage) async -> String? { // (반환) -> 사진을 올린 주소
        // jpegData를 사용하면 파일이 jpeg로 압축됨
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString // (파일이름 생성)임의의 문자열(고유한 ID?)
        print("fileName:", fileName)
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)") // 이미지가 저장될 위치 설정(withPath: images라는 폴더내에 fileName으로 저장)
        
        do {
            // try await 같이 사용(여기서 async를 비동기 처리하지 않고 상위로 넘길 것임 -> 감싸고 있는 메서드를 async 처리)
            // 이미지를 업로드하고 metaData에 이미지가 올라간 정보에 대한 것이 저장됨
            let metaData = try await reference.putDataAsync(imageData) // putDataAsync를 사용하여 이미지 업로드(async로 동작하는 함수이므로 동시성 환경을 만들어줘야하고 throws도 던지므로 에러 처리도 해줘야함)
            print("metaData:", metaData)
            // 이미지가 올라간 것을 게시글에 저장하는데 데이터는 Storage에 저장하고, 이미지가 올라간 URL만 게시글(uploadPost)에 저장할 것
            let url = try await reference.downloadURL() // 다운로드 받는 URL 제공
            
            return url.absoluteString // 전체주소 URL 반환(String으로 변경해서)
        } catch {
            print("DEBUG: Failed to  upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}

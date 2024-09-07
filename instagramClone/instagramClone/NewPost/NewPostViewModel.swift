//
//  NewPostViewModel.swift
//  instagramClone
//
//  Created by 유성열 on 9/7/24.
//
import SwiftUI
import PhotosUI
import FirebaseStorage // (대용량 DB)FireBase Storage 사용
import Firebase
import FirebaseFirestore

// MARK: - (NewPost)ViewModel

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
    // MARK: 정리하자면 이미지와 함께 게시글을 올리면 이미지는 (대용량)Storage 부분에 올라가고 게시글은 FireStore DataBase에 올라가는 것(이미지 저장된 URL과 함꼐)
    func uploadPost() async { // async를 한번 더 상위로 넘김(View에서 Task 처리할 것임)
        guard let uiImage else { return } // (팁) 옵셔널 바인딩할때 guard let uiImage = self.uiImage else 이렇게 할때 변수이름이 똑같다면 생략 가능함
        guard let imageUrl = await uploadImage(uiImage: uiImage) else { return }// url은 Firebase에서 사진을 내려받을 수 있는 주소임(이미지가 저장된 주소)
        
        // FireStore 인스턴스 생성하면서 컬렉션 추가
        // 게시글은 Firestore Database에서 저장(이미지는 대용량으로서 Storage에 저장했음)
        // Firebase Database에는 collection과 document 개념이 존재하는데, (excel로 치면)collection은 하나의 '시트'이고 도큐먼트는 하나의 '행' 같은 개념 (postReference는 post의 저장할 위치 정보를 담게 됨)
        let postReference = Firestore.firestore().collection("posts").document() // "posts" 라는 컬렉션(하나의 그룹)을 만들고 -> 그 안에 있는 모든 document에 접근(document에 인자값 전달하여 원하는 값만 뽑아낼 수도 있음)
        // documnetID는 FireStore에서 각 문서를 고유하게 식별하는 ID로서 사용자 지정으로 생성하거나 자동 생성이됨
        let post = Post(id: postReference.documentID, caption: caption, like: 0, imageUrl: imageUrl, date: Date()) // 업로드해야할 정보 만듦(Post Model) (documentID는 새로운 ID를 제공해주는 것)
        
        // (업로드 전)encode를 해줘야함(내가 만든 Post 모델은 Swift문법이므로 Firebase에서 이해할 수 있도록 인코딩해서 업로드 -> 파베에서는 알아서 디코딩해서 사용할 것)
        do {
            let encodedData = try Firestore.Encoder().encode(post)
            try await postReference.setData(encodedData) // 인코딩된 데이터를 업로드(async 함수)
        } catch {
            print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
        }
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
    
    // 게시글 업로드 후 정보 초기화
    func clearData() {
        caption = ""
        selectedItem = nil
        postImage = nil
        uiImage = nil
    }
}

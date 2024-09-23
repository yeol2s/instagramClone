//
//  ImageManager.swift
//  instagramClone
//
//  Created by 유성열 on 9/21/24.
//
// MARK: - ImageManager(이미지들을 관리하는 이미지 매니저)
// NewPostViewModel, ProfileViewModel에서 convertImage, uploadImage메서드가 중복 구현되어 있으므로 코드 리펙토링으로 이미지 매니저를 따로 만듦

import SwiftUI
import PhotosUI
import FirebaseStorage

// MARK: ImageSelection Model(튜플로 하는 방법 대신)
struct ImageSelection {
    let image: Image
    let uiImage: UIImage
}

// MARK: Firebase Storage path 설정(enum)
// 기존에는 문자열로 직접 인자값 전달받았지만 오타에 취약하고 열거형으로 한곳에서 관리하는 것이 좋음
enum ImagePath {
    case post
    case profile
}

// 이미지를 관리할 클래스
class ImageManager {
    // PhotosPicker item을 이미지로 변환해주는 메서드(이미지 장착하는 것)
    static func convertImage(item: PhotosPickerItem?) async -> ImageSelection? { // static 선언(인스턴스화 하지 않고 타입메서드로 사용)
        guard let item = item else { return nil }
        // MARK: Data -> Image로 바로 변환이 안되므로 Data -> UIImage -> Image로 변환
        // * 과정 : PhotosPikcerItem -> Data(바이너리) -> UIImage(UIKit) -> Image(SwiftUI)
        // 1. loadTransferable : PhotosPicker item을 Data 형식(바이너리-0,1)으로 변경
        // 여기서 await을 비동기 처리 하지 않은 이유는 위 메서드에서 async를 사용하므로써 상위로 넘겨준 것
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        // 2. data를 UIKit의 UIImage로 변경
        guard let uiImage = UIImage(data: data) else { return nil }
        // 3. SwiftUI Image 형식으로 변경
        let image = Image(uiImage: uiImage) // profile, post 이미지 통합해서 변수명을 image로 통일
        // 모델 만들어서 반환할 이미지들 묶음
        let imageSelection = ImageSelection(image: image, uiImage: uiImage)
        return imageSelection
    }
    
    // 사진 업로드(게시글을 업로드 하면서 여러가지 정보중에 (게시글 내부에서)사진이 같이 업로드되는 것)
    // 구현된 부분에서 다른 부분은 다 공통적으로 사용되나 storage.reference부분에서 withPath 부분에 경로이름이 NewPostViewModel은 "/images/", ProfileViewModel은 "/profiles/"로 각각 다르다. 그래서 인자로 전달받아 처리
//    static func uploadImage(uiImage: UIImage, path: String) async -> String? { // (Old) ImagePath 열거형 사용 전
    static func uploadImage(uiImage: UIImage, path: ImagePath) async -> String? { // (반환) -> 사진을 올린 주소
        // jpegData를 사용하면 파일이 jpeg로 압축됨
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString // (파일이름 생성)임의의 문자열(고유한 ID?)
        print("fileName:", fileName)
        var imagePath: String = ""

        switch path { // path 열거형 분기처리
        case .post:
            imagePath = "images"
        case .profile:
            imagePath = "profiles"
        }
        
        // (Old)
        //let reference = Storage.storage().reference(withPath: "/\(path)/\(fileName)") // 이미지가 저장될 위치 설정(withPath: 정해진 폴더내에 fileName으로 저장)
        let reference = Storage.storage().reference(withPath: "/\(imagePath)/\(fileName)") // (New)
        
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


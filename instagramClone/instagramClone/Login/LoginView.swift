//
//  LoginView.swift
//  instagramClone
//
//  Created by 유성열 on 9/8/24.
//
// MARK: - LoginView

import SwiftUI

struct LoginView: View {
    
    // (그라디언트 사용) 실제 인스타그램 앱 백그라운드 컬러 추출한 것
    // RGB 0~255 단위를 255로 나눈 값(0~1사이) (굳이 이렇게 0~1 단위로 입력하지 않아도 인자값으로 바로 255 나눠버려도 됨)
    // ex) let yellowColor = Color(red: 255/255, green: 249/255, blue: 241/255)
    let yellowColor = Color(red: 0.9960784314, green: 0.9764705882, blue: 0.9529411765)
    let redColor = Color(red: 0.9921568627, green: 0.9490196078, blue: 0.9725490196)
    let blueColor = Color(red: 0.9333333, green: 0.968627451, blue: 0.9960784314)
    let greenColor = Color(red: 0.937254902, green: 0.9882352941, blue: 0.9529411765)
    
    var body: some View {
        
        // (기본)그라디언트 설정(블루(탑에서 시작)->레드(바텀))
//        LinearGradient(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom)
        // (정밀)그라디언트 설정(Stop(location: 값)으로 색이 섞이지 않는 영역을 지정할 수 있음)
        LinearGradient(stops: [
            Gradient.Stop(color: yellowColor, location: 0.1),
            Gradient.Stop(color: redColor, location: 0.3),
            Gradient.Stop(color: blueColor, location: 0.6),
            Gradient.Stop(color: greenColor, location: 1)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea() // safeArea영역까지 그라디언트 설정
    }
}

#Preview {
    LoginView()
}

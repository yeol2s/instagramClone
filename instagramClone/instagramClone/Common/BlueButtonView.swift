//
//  BlueButtonView.swift
//  instagramClone
//
//  Created by 유성열 on 9/13/24.
//
// MARK: - LoginView의 '로그인'버튼, CompleteSignupView의 '완료' 버튼을 공통화 시키기 위한 ViewBuilder
// 버튼이라는 것과 모디파이어(디자인)이 동일하지만 '로그인', '완료' 라는 텍스트에서 차이가 있다. 그리고 버튼을 눌렀을 때의 기능이 다르다.

import SwiftUI

struct BlueButtonView<Content: View>: View {
    
    // MARK: 기존 Button 구성과 동일하게 기존에 content로 작성되었던 변수명을 label로 변경함
    let label: Content
    let action: () -> Void
    
    // 생성자 파라미터에 ViewBuilder 선언
    // ViewBuilder가 사용된 클로저 안에서는 여러개의 뷰를 받아서 반환할 수 있음(여러 뷰를 하나의 View로 결합하여 반환 - 하나의 뷰로 묶음)
    // MARK: 이 뷰빌더는 view와 함께 action도 받아야 하므로 action 매개변수를 만듦
    // Button에서 view 부분은 label에서 가지고 있는 view가 될 것이고, action은 Button을 눌렀을 때 실행될 부분
    // MARK: (인자값)action이 @escaping이 필요한 이유는 View가 생성된 후에도 사용자가 Button을 누를때 까지 action은 참조되어야 하므로(나중에 호출되므로) @escaping이 필요함
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button {
            action() // 여기서 액션을 실행
        } label: {
            label // Button으로 감싸준다.(이게 결국 Text View인 것)
                .foregroundStyle(.white)
                .frame(width: 363, height: 42)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

// MARK: - 기존 Button 구현
//Button {
//    print("로그인 되었습니다.") // 다른 부분1
//} label: {
//    Text("로그인") // 다른 부분2
//        .foregroundStyle(.white)
//        .frame(width: 363, height: 42)
//        .background(.blue)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//}

//
//  Date+relativeTimeString.swift
//  instagramClone
//
//  Created by 유성열 on 9/26/24.
//
// MARK: - Date 구조체 확장 기능 구현
// (Date 구조체 확장)게시글 업로드 날짜 표시 문자열로 반환해주는 relativeTimeString 메서드 구현

import Foundation

extension Date {
    func relativeTimeString() -> String {
        let now = Date() // 현재 시간 인스턴스 생성
        let currentYear = Calendar.current.component(.year, from: now) // now 인스턴스가 몇년도인지 컴포넌트를 뽑아냄
        let thisYearFirstDay = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))! // 올해 1월 1일 Date를 변수에 저장(올해인지 아닌지 체크하기 위해서 사용함)
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth, .month], from: self, to: now) // now 인스턴스를 다 분해해서 초, 분, 시, 일, 주, 월로 분리해서 컴포넌트에 저장하는 것(아래에서 가져다 쓰기 위해)
        
        if let month = components.month, month >= 1 { // (한달이 넘는지)지금으로 부터 한달 이전인지(한달보다 과거면 00월 00일, 작년이나 그 이전 이면 0000년 00월 00일 이런식으로 표현)
            let dateFormatter = DateFormatter()
            
            // 이 날짜가 올해 1월 1일 이전인지 확인
            if self < thisYearFirstDay {
                dateFormatter.dateFormat = "yyyy년 M월 d일" // 이전이면 년도 포함해서 반환
            } else {
                dateFormatter.dateFormat = "M월 d일" // 이후면 월,일만 표시하여 반환
            }
            return dateFormatter.string(from: self) // dateFormaater로 문자열 변환하여 반환
        } else if let week = components.weekOfMonth, week >= 1 { // 1주보다 큰지(한달 넘어가면 위에서 걸러짐)
            return "\(week)주 전"
        } else if let day = components.day, day >= 1 { // 1일보다 더 크고 1주보다 작으면
            return "\(day)일 전"
        } else if let hour = components.hour, hour >= 1 { // 이런식으로 쭉...
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        } else if let second = components.second, second >= 1 {
            return "\(second)초 전"
        } else { // 1초가 지나지 않았을 때
            return "방금"
        }
    }
}

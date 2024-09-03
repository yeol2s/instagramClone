//
//  ImageFitAndFillView.swift
//  instagramClone
//
//  Created by 유성열 on 9/4/24.
//
// MARK: - 이미지 비율 조정 함수 설명(프로젝트와는 관계 없음)

import SwiftUI

struct ImageFitAndFillView: View {
    var body: some View {
        VStack {
            // MARK: - Nomal(주석처리)
            //            Image(systemName: "trash.square.fill")
            ////                .resizable() // 뷰가 차지할 수 있는 최대 영역을 차지함(이미지 크기 조정이 가능하도록 만듦)
            //
            //            Rectangle()
            //                .frame(width: 200, height: 100)
            
            // MARK: - 이 경우는 이미지 크기가 설정된 frame값대로 사이즈는 조정되지만 이미지 원본 비율이 깨진다. resizable만 하고 frame만 설정했을 때는 frame 크기 만큼만 꽉 차게 된다.(비율은 무시한 채)
            Image(systemName: "trash.square.fill")
                .resizable()
                .frame(width: 200, height: 100)
            
            // MARK: - aspectRatio '.fit' 설정(원본 비율 유지)
            // fit: 이미지가 커지다가 한쪽 면(가로or세로)이 꽉차는 순간이 오면 멈춘다.(frame 크기 내에서)
            Image(systemName: "trash.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 100)
                .border(.pink, width: 2)
            
            // MARK: - aspectRatio '.fill' 설정(원본 비율 유지)
            // fill: 이미지가 커지다가 한쪽 면(가로or세로)이 꽉차고 난 후 다음 면 까지 꽉 찰때 까지 진행
            Image(systemName: "trash.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 100)
                .border(.blue, width: 1)
                .clipped() // fill을 사용할 때는 clipped 메서드를 자주 사용한다.(넘어간 이미지를 잘라버림 - 보통 프로필 사진에서 많이 사용)
            
            /* 정리하자면 fit은 이미지를 원본 비율 유지하면서 커지는데 공백이 생길 수 있고
             fill은 원본 비율 유지하면서 커지는데 이미지가 잘릴 수 있다. */
            
            // MARK: - aspectRatio -> scaledToFit(Fill) 동일한 기능의 함수
            Image(systemName: "trash.square.fill")
                .resizable()
                .scaledToFit() // aspectRatio(.fit)과 동일
                .frame(width: 200, height: 100)
                .border(.pink, width: 2)
            
            Image(systemName: "trash.square.fill")
                .resizable()
                .scaledToFill() // aspectRatio(.fill)과 동일
                .frame(width: 200, height: 100)
                .border(.blue, width: 1)
                .clipped()
            
            // MARK: - aspectRatio(aspectRatio: contentMode:) -> 2개의 인자값 사용
            // 처음 인자값 aspectRatio는 비율을 정해주는 것(이 인자를 사용하지 않으면 그냥 원본 비율을 살리는 것)
            Image(systemName: "trash.square.fill")
                .resizable()
                //.aspectRatio(contentMode: .fit)
            /*
             aspectRatio: 커질수록 가로가 커진다.
             1 = 가로 세로 1:1
             2 = 가로 세로 2:1
             2/1(분자/분모) = 가로(분자) 2 : 1 세로(분모)
             3/1 = 가로가 3이 되면서 첫 번째 닫는 면적이 가로가 되면서 세로에 빈 공간이 생긴다(fit의 특성상)
             */
                .aspectRatio(2, contentMode: .fit)
                .frame(width: 200, height: 100)
                .border(.pink, width: 2)
            
            Image(systemName: "trash.square.fill")
                .resizable()
                //.aspectRatio(contentMode: .fill)
                .aspectRatio(3, contentMode: .fill)
                .frame(width: 200, height: 100)
                .border(.blue, width: 1)
                .clipped()
            
            
        } //:VSTACK
    }
}

#Preview {
    ImageFitAndFillView()
}

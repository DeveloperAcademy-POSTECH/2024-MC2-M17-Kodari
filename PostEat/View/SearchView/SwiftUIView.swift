//
//  SearchResultCell.swift
//  Pre Kodari
//
//  Created by sanghyuk on 5/18/24.
//

import Foundation
import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        
        ZStack{
            Color("backgroundGrayColor")
                .ignoresSafeArea() // 미리보기용 배경색 나중에 삭제
            
            ZStack{
                Rectangle()
                    .frame(width: 360, height: 154)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                VStack{
                    HStack{
                        counterBadge // 식수 인원
                        Spacer()
                        dateBadge // 날짜 date
                        mealTypeBadge // 조식 / 중식 / 석식 여부
                        
                    }
                    .padding(EdgeInsets(top: 14, leading: 30, bottom: 10, trailing: 30))
                    
                    HStack(alignment: .bottom) {
                        mealContents
                        Spacer()
                        noteAndWeatherIcon
                        
                    }
                    .padding(EdgeInsets(top: 2, leading: 30, bottom: 0, trailing: 30))
                }
            }
            .frame(width: 360, height: 154)
        }
        
    }
    
    // MARK: 식수
    var counterBadge: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 68.39539, height: 22)
                .background(Constants.KODARIBlue)
                .cornerRadius(6)
            
            Text("293명 방문")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 11)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.White)
                .frame(width: 60, height: 11, alignment: .center)
        }
    }
    
    // MARK: 날짜
    var dateBadge: some View{
        
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 130, height: 20)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("2024년 3월 27일 수요일")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 11)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 110, height: 13, alignment: .center)
        }
    }
    
    // MARK: Meal Type
    var mealTypeBadge: some View{
        
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 37, height: 20)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("중식")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 11)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 29.80556, height: 13, alignment: .center)
        }
    }
    
    // MARK: 식단
    var mealContents: some View{
        
        Text("살인미소된장국\n닭갈비\n콩나물무침\n스크류바")
            .font(
                Font.custom("Apple SD Gothic Neo", size: 15)
                    .weight(.semibold)
            )
            .foregroundColor(Constants.POSTECHGray)
            .frame(width: 160, height: 87, alignment: .topLeading)
    }
    
    // MARK: 메모 & 날씨
    var noteAndWeatherIcon: some View{
        
        HStack{
            Image(systemName:"chart.line.uptrend.xyaxis.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Constants.KODARIGray)
                .frame(width: 15,alignment: .leading)
                .padding()
            
            Image(systemName:"cloud.heavyrain.fill")
                .font(.system(size: 20))
                .foregroundColor(Constants.KODARIGray)
                .frame(width: 15,alignment: .trailing)
            
        }
    }
}
struct SearchCard_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

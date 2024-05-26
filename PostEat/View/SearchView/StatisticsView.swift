import SwiftUI

// MARK: 통계 데이터 View
struct StatisticsView: View {
    
    @Binding var weekdayMaxNum: Int
    @Binding var weekdayMinNum: Int
    @Binding var weekdayAvgNum: Int
    
    @Binding var weekendMaxNum: Int
    @Binding var weekendMinNum: Int
    @Binding var weekendAvgNum: Int
    
    @Binding var weekdayProgressValue: Float
    @Binding var weekendProgressValue: Float
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("방문자 수")
                        .fontWeight(.semibold)
                }
                .padding()
                
                HStack {
                    VStack {
                        Text("평일")
                        ZStack {
                            WeekdayProgressBar(weekdayprogress: self.$weekdayProgressValue, weekdayAvgNum: weekdayAvgNum)
                                .frame(width: 80.0, height: 80.0)
                                .padding(.top, 10)
                            
                            HStack {
                                Text("\(weekdayMinNum)")
                                    .foregroundColor(Constants.POSTECHGray)
                                Spacer()
                                Text("\(weekdayMaxNum)")
                                    .foregroundColor(Constants.POSTECHRed)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 80)
                        }
                    }
                    
                    VStack {
                        Text("주말")
                        ZStack {
                            WeekendProgressBar(weekendprogress: self.$weekendProgressValue, weekendAvgNum: weekendAvgNum)
                                .frame(width: 80.0, height: 80.0)
                                .padding(.top, 10)
                            
                            HStack {
                                Text("\(weekendMinNum)")
                                    .foregroundColor(Constants.POSTECHGray)
                                Spacer()
                                Text("\(weekendMaxNum)")
                                    .foregroundColor(Constants.POSTECHRed)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 80)
                        }
                    }
                }
                
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Constants.POSTECHGray)
                    Text("최저")
                        .foregroundColor(Constants.POSTECHGray)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Constants.KODARIBlue)
                    Text("평균")
                        .foregroundColor(Constants.KODARIBlue)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Constants.POSTECHRed)
                    Text("최고")
                        .foregroundColor(Constants.POSTECHRed)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.3))
                .cornerRadius(15)
                .padding()
            }
            .background(Constants.KODARIGray.opacity(0.15))
            .cornerRadius(12)
        }
    }
}

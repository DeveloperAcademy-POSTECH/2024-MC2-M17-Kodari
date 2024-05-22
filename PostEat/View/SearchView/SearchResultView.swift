import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String
    @State var mealsdata: [FoodData]
    
    let columns = [GridItem(.flexible())]
    
    // MARK: 인사이트 통계 변수들
    @State var weekdayMaxNum = "" // 평일 최대 인원
    @State var weekdayMinNum = "" // 평일 최소 인원
    @State var weekdayAvgNum = "" // 평일 평균 인원
    
    @State var weekendMaxNum = "" // 주말 최대 인원
    @State var weekendMinNum = "" // 주말 최소 인원
    @State var weekendAvgNum = "" // 주말 평균 인원
    
    @State var progressValue1: Float = 0.65
    @State var progressValue2: Float = 0.45
    
    
    var body: some View {
        ZStack {
            Color(Constants.AppleGray)
                .edgesIgnoringSafeArea(.bottom)
            
            ScrollView {
                VStack{
                    VStack{
                        VStack{
                            HStack(spacing:0){
                                Text("\(searchMenu)")
                                    .foregroundColor(Color(Constants.POSTECHRed))
                                    .font(.system(size: 22))
                                    .bold()
                                Text("이(가) 포함된 식단")
                                    .font(.system(size: 22))
                                    .bold()
                                Spacer()
                            }
                            .background(.clear)
                            .padding(18)
                            
                            VStack{
                                VStack{
                                    HStack{
                                        Text("방문자 수")
                                            .fontWeight(.semibold)
                                    }
                                    .padding()
                                    
                                    HStack{
                                        VStack{
                                            Text("평일")
                                            ZStack{
                                                WeekdayProgressBar(weekdayprogress: progressValue1, weekdayAvgNum: weekdayAvgNum)
                                                    .frame(width: 80.0, height: 80.0)
                                                    .padding(.top, 10)
                                                
                                                HStack{
                                                    Text("\(weekdayMinNum)")
                                                        .foregroundColor(Constants.KODARIRed)
                                                    Spacer()
                                                    Text("\(weekdayMaxNum)")
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.top, 80)
                                            }
                                            
                                        }
                                        VStack{
                                            Text("주말")
                                            ZStack{
                                                WeekendProgressBar(weekendprogress: self.$progressValue2, weekendAvgNum: weekendAvgNum)
                                                    .frame(width: 80.0, height: 80.0)
                                                    .padding(.top, 10)
                                                
                                                HStack{
                                                    Text("\(weekendMinNum)")
                                                        .foregroundColor(Constants.KODARIRed)
                                                    Spacer()
                                                    Text("\(weekendMaxNum)")
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.top, 80)
                                            }
                                            
                                        }
                                    }
                                    HStack{
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.blue)
                                        Text("평균")
                                            .foregroundColor(.blue)
                                        
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.red)
                                        Text("최고")
                                            .foregroundColor(.red)
                                        
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.black)
                                        Text("최저")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(15)
                                    .padding()
                                }
                                .background(Constants.AppleGray)
                                .cornerRadius(15)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.white)
                    .cornerRadius(15)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredFoodData, id: \.id) { item in
                            CustomCellView(foodData: item)
                        }
                    }
                    .background(.clear)
                    .cornerRadius(15)
                    .padding(.top)
                }
                .padding(18)
            }
            .onAppear {
                updateStatistics() // 현재 ResultView로 넘어오면서 바로 함수실행 -> 통계데이터 계산
            }
        }
        .navigationTitle("검색결과")
    }
    
    private var filteredFoodData: [FoodData] {
        return mealsdata.filter { item in
            let searchLowercased = searchMenu.lowercased()
            return item.menu1.lowercased().contains(searchLowercased) ||
            item.menu2.lowercased().contains(searchLowercased) ||
            item.menu3.lowercased().contains(searchLowercased) ||
            item.menu4.lowercased().contains(searchLowercased)
        }
    }
    
    // MARK: 인사이트 - 통계 데이터 ( 주말 & 평일 구분 )
    private func updateStatistics() {
        guard !filteredFoodData.isEmpty else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        var weekdayArray: [Int] = [] // 평일인경우
        var weekendArray: [Int] = [] // 주말인경우
        
        for data in filteredFoodData {
            if let date = dateFormatter.date(from: data.date) {
                let calendar = Calendar.current
                let components = calendar.component(.weekday, from: date)
                // 1: 일요일, 2: 월요일, ..., 7: 토요일
                if components == 1 || components == 7 {
                    weekendArray.append(Int(data.num) ?? 0)
                } else {
                    weekdayArray.append(Int(data.num) ?? 0)
                }
            }
        }
        print("평일 Total : \(weekdayArray)")
        print("주말 Total : \(weekendArray)")
        
        // 주중 통계
        if let maxNum = weekdayArray.max() {
            weekdayMaxNum = "\(maxNum)"
            print("펑일 max: \(maxNum)")
        }
        
        let weekdayNonZeroArray = weekdayArray.filter { $0 != 0 }
        if let minNum = weekdayNonZeroArray.min() {
            weekdayMinNum = "\(minNum)"
            print("평일 min: \(weekdayMinNum)")
        } else {
            weekdayMinNum = "0"
            print("평일 min: \(weekdayMinNum)")
        }
        
        let weekdayTotal = weekdayNonZeroArray.reduce(0, +)
        print("평일 미입력 제외 Total: \(weekdayTotal)")
        let weekdayAverage = weekdayTotal / max(weekdayNonZeroArray.count, 1)
        weekdayAvgNum = "\(weekdayAverage)"
        print("평일 avg: \(weekdayAvgNum)")
        
        // 주말 통계
        if let maxNum = weekendArray.max() {
            weekendMaxNum = "\(maxNum)"
            print("주말 max: \(weekendMaxNum)")
        } else {
            weekendMaxNum = "0"
            print("주말 max: \(weekendMaxNum)")
        }
        
        
        let weekendNonZeroArray = weekendArray.filter { $0 != 0 }
        if let minNum = weekendNonZeroArray.min() {
            weekendMinNum = "\(minNum)"
            print("주말 min: \(weekendMinNum)")
        } else {
            weekendMinNum = "0"
            print("주말 min: \(weekendMinNum)")
        }
        
        let weekendTotal = weekendNonZeroArray.reduce(0, +)
        print("주말 미입력 제외 Total: \(weekendTotal)")
        let weekendAverage = weekendTotal / max(weekendNonZeroArray.count, 1)
        weekendAvgNum = "\(weekendAverage)"
        print("주말 avg: \(weekendAvgNum)")
    }
    
}

struct WeekdayProgressBar: View {
    var weekdayprogress: Float
    var weekdayAvgNum: String
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: CGFloat(self.weekdayprogress))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .fill(Color.blue)
                .rotationEffect(.degrees(54.5)) // 게이지 시작 지점 - Start Point
            
            VStack{
                Text("\(weekdayAvgNum)")
                    .foregroundColor(.blue)
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
            }
        }
    }
}

struct WeekendProgressBar: View {
    @Binding var weekendprogress: Float
    var weekendAvgNum: String
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: CGFloat(self.weekendprogress))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .fill(Color.blue)
                .rotationEffect(.degrees(54.5)) // 게이지 시작 지점 - Start Point
            
            VStack{
                Text("\(weekendAvgNum)")
                    .foregroundColor(.blue)
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: Cell View
struct CustomCellView: View {
    
    let foodData: FoodData
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 날짜 형식 설정
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                counterBadge(count: foodData.num)
                Spacer()
                dateBadge(day: foodData.date)
                mealTypeBadge(mealType: foodData.uniqueid)
            }
            .padding(.top, 10)
            .padding(.horizontal, 15)
            
            HStack {
                mealContents(menu1: foodData.menu1, menu2: foodData.menu2, menu3: foodData.menu3, menu4: foodData.menu4)
                Spacer()
                //                noteAndWeatherIcon
                //                    .padding(.top, 60)
                //                    .padding(.leading, 50)
            }
            .padding(EdgeInsets(top: 2, leading: 15, bottom: 10, trailing: 30))
        }
        .frame(maxWidth: .infinity)
        //.padding(15)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    // MARK: 식수
    func counterBadge(count: Int) -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width:80, height:22)
                .background(Constants.KODARIBlue)
                .cornerRadius(9)
            
            Text(count == 0 ? "미입력" : "\(count)명 방문") // 0명이면 "미입력"으로
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.White)
                .frame(width: 80, height: 11, alignment: .center)
        }
    }
    
    // MARK: 날짜
    func dateBadge(day: String) -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 170, height: 22)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("\(parseDateString(day))")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 170, height: 13, alignment: .center)
        }
    }
    
    func parseDateString(_ dateString: String) -> String {
        let components = dateString.split(separator: ":")
        if components.count == 3 {
            let year = String(components[0])
            let month = String(components[1])
            let day = String(components[2])
            
            // 날짜 문자열을 Date 객체로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"
            guard let date = dateFormatter.date(from: dateString) else {
                return dateString
            }
            
            // Date 객체를 원하는 형식의 문자열로 변환
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
            let formattedDateString = dateFormatter.string(from: date)
            
            return formattedDateString
        } else {
            return dateString
        }
    }
    
    // MARK: 식단
    func mealContents(menu1: String, menu2: String, menu3: String, menu4: String)-> some View{
        
        VStack(alignment: .leading, spacing: 0.5){
            Text(menu1)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                .padding(2)
            Text(menu2)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                .padding(2)
            Text(menu3)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                .padding(2)
            Text(menu4)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                .padding(2)
        }
        
    }
    
    // MARK: Meal Type
    func mealTypeBadge(mealType: String)-> some View{
        let mealTypeText: String
        switch mealType.last { // uniqueid의 마지막 문자를 확인하여 조식, 중식, 석식 텍스트 설정
        case "M":
            mealTypeText = "조식"
        case "L":
            mealTypeText = "중식"
        case "D":
            mealTypeText = "석식"
        default:
            mealTypeText = "알 수 없음"
        }
        
        return ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 37, height: 22)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("\(mealTypeText)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 29.80556, height: 13, alignment: .center)
        }
    }
    //    var noteAndWeatherIcon: some View{
    //        HStack{
    //            Image(systemName:"chart.line.uptrend.xyaxis.circle.fill")
    //                .font(.system(size: 20))
    //                .foregroundColor(Constants.KODARIGray)
    //                .frame(width: 15,alignment: .leading)
    //                .padding()
    //
    //            Image(systemName:"cloud.heavyrain.fill")
    //                .font(.system(size: 20))
    //                .foregroundColor(Constants.KODARIGray)
    //                .frame(width: 15,alignment: .trailing)
    //        }
    //    }
}

//#Preview {
//    SearchResultsView(searchMenu: "서치메뉴", mealsdata: [
//        FoodData(uniqueid: "1", date: "2024-05-20", menu1: "Menu 1", menu2: "Menu 2", menu3: "Menu 3", menu4: "Menu 4", num: 123, memo:""),
//        FoodData(uniqueid: "2", date: "2024-05-21", menu1: "Menu A", menu2: "Menu B", menu3: "Menu C", menu4: "Menu D", num: 123, memo:"")
//    ])
//}

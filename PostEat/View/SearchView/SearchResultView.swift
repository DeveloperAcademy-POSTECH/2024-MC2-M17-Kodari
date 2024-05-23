import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String // 검색한 메뉴 이름
    @State var mealsdata: [FoodData]
    
    let columns = [GridItem(.flexible())]
    
    // MARK: 인사이트 통계 변수들
    
    @State var weekdayMaxNum = "" // 평일 최대 인원
    @State var weekdayMinNum = "" // 평일 최소 인원
    @State var weekdayAvgNum = "" // 평일 평균 인원
    
    @State var weekendMaxNum = "" // 주말 최대 인원
    @State var weekendMinNum = "" // 주말 최소 인원
    @State var weekendAvgNum = "" // 주말 평균 인원
    
    /// Progress Bar Value
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
                                if searchMenu.count > 6 {
                                    VStack(alignment: .leading){
                                        HStack(spacing: 0){
                                            Text("\(searchMenu)")
                                                .foregroundColor(Color(Constants.POSTECHRed))
                                                .font(.system(size: 22))
                                                .bold()
                                            
                                            Text("\(josaDecision(searchMenu))")
                                                .font(.system(size: 22))
                                                .bold()
                                        }
                                        Text("포함된 식단")
                                            .font(.system(size: 22))
                                            .bold()
                                    }
                                    Spacer()
                                } else {
                                    Text("\(searchMenu)")
                                        .foregroundColor(Color(Constants.POSTECHRed))
                                        .font(.system(size: 22))
                                        .bold()
                                    Text("\(josaDecision(searchMenu)) 포함된 식단")
                                        .font(.system(size: 22))
                                        .bold()
                                    Spacer()
                                }
                            }
                            .background(.clear)
                            .padding(.top)
                            .padding(.leading)
                            
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
                                                        .foregroundColor(Constants.POSTECHGray)
                                                    Spacer()
                                                    Text("\(weekdayMaxNum)")
                                                        .foregroundColor(Constants.POSTECHRed)
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
                                    HStack{
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
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.white)
                    .cornerRadius(20)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredFoodData, id: \.id) { item in
                            CustomCellView(foodData: item, searchMenu: searchMenu)
                        }
                    }
                    .background(.clear)
                    .cornerRadius(20)
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
    
    // MARK: 조사 알고리즘
    func josaDecision(_ name: String) -> String {
        // 글자 마지막 부분 가져오기
        guard let lastText = name.last else { return name }
        // 유니코드 변환
        let unicodeVal = UnicodeScalar(String(lastText))?.value
        
        guard let value = unicodeVal else { return name }
        // 한글아니면 반환
        if (value < 0xAC00 || value > 0xD7A3) { return name }
        // 종성인지 확인
        let last = (value - 0xAC00) % 28
        // 받침있으면 "이" 없으면 "가" 반환
        let str = last > 0 ? "이" : "가"
        return str
    } //조사결정
    
    // MARK: 메뉴 검색 필터
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
                .fill(Constants.KODARIBlue)
                .rotationEffect(.degrees(54.5)) // 게이지 시작 지점 - Start Point
            
            VStack{
                Text("\(weekdayAvgNum)")
                    .foregroundColor(Constants.KODARIBlue)
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
                .fill(Constants.KODARIBlue)
                .rotationEffect(.degrees(54.5)) // 게이지 시작 지점 - Start Point
            
            VStack{
                Text("\(weekendAvgNum)")
                    .foregroundColor(Constants.KODARIBlue)
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: Cell View
struct CustomCellView: View {
    
    let foodData: FoodData
    let searchMenu: String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 날짜 형식 설정
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack {
                mealTypeBadge(mealType: foodData.uniqueid, noCount: foodData.num)
                counterBadge(count: foodData.num, tempdate: foodData.date)
                dateBadge(day: foodData.date, noCount: foodData.num)
            }
            
            HStack{
                Divider()
                    .frame(maxHeight: .infinity) // 높이를 적절히 설정
                    .background(Constants.AppleGray)
            }
            .padding(.vertical, 10)
            
            VStack {
                mealContents(menu1: foodData.menu1, menu2: foodData.menu2, menu3: foodData.menu3, menu4: foodData.menu4)
            }
            .padding(10)
            Spacer()
            
            VStack{
                noteAndWeatherIcon(useMemo: foodData.memo)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(25)
    }
    
    // MARK: 식수
    func counterBadge(count: Int, tempdate: String) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("변형전 :\(tempdate)")
        let date = formatter.date(from: tempdate) ?? Date()
        print("변형후 : \(date)")
        print("현재 Current : \(Calendar.current)")
        let isFutureDate = Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
        print("비교: \(isFutureDate)")
        
        var displayText: String
        if count == 0 {
            if isFutureDate {
                displayText = "배식전"
            } else {
                displayText = "미입력"
            }
        } else {
            displayText = "\(count)명"
            print("\(displayText) 가능")
        }
        
        return ZStack {
            Rectangle()
                .frame(width: 80, height: 22)
                .foregroundColor(.clear)
            
            Text(displayText)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 26)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(displayText == "미입력" ? Constants.KODARIGray : Constants.KODARIBlue)
                .frame(width: 80, height: 22, alignment: .center) // Adjusted height to match the parent Rectangle
        }
    }
    
    // MARK: 날짜
    func dateBadge(day: String, noCount: Int) -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 70, height: 30)
            
            Text("\(parseDateString(day).datePart) \n \(parseDateString(day).dayOfWeek)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 12)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(noCount == 0 ? Constants.KODARIGray : Constants.POSTECHGray)
                .frame(alignment: .center)
        }
    }
    
    // MARK: 날짜 형변환
    func parseDateString(_ dateString: String) -> (datePart: String, dayOfWeek: String) {
        let components = dateString.split(separator: ":")
        if components.count == 3 {
            let year = String(components[0])
            let month = String(components[1])
            let day = String(components[2])
            
            // 날짜 문자열을 Date 객체로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"
            guard let date = dateFormatter.date(from: dateString) else {
                return (dateString, "")
            }
            
            // Date 객체를 원하는 형식의 문자열로 변환
            dateFormatter.dateFormat = "MM월 dd일"
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
            let datePart = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateFormatter.string(from: date)
            
            return (datePart, dayOfWeek)
        } else {
            return (dateString, "")
        }
    }
    
    // MARK: Menus
    func mealContents(menu1: String, menu2: String, menu3: String, menu4: String)-> some View{
        
        return VStack(alignment: .leading, spacing: 0.5){
            
            Text(menu1)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu1 == searchMenu ? .bold : .regular) // 조건에 따라 bold체 또는 regular체 선택
                )
                .foregroundColor(menu1 == searchMenu ? Constants.POSTECHRed : Color.black)
                .padding(2)
            
            Text(menu2)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu2 == searchMenu ? .bold : .regular) // 조건에 따라 bold체 또는 regular체 선택
                )
                .foregroundColor(menu2 == searchMenu ? Constants.POSTECHRed : Color.black)
                .padding(2)
            Text(menu3)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu3 == searchMenu ? .bold : .regular) // 조건에 따라 bold체 또는 regular체 선택
                )
                .foregroundColor(menu3 == searchMenu ? Constants.POSTECHRed : Color.black)
                .padding(2)
            Text(menu4)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu4 == searchMenu ? .bold : .regular) // 조건에 따라 bold체 또는 regular체 선택
                )
                .foregroundColor(menu4 == searchMenu ? Constants.POSTECHRed : Color.black)
                .padding(2)
        }
        
    }
    
    // MARK: Meal Type
    func mealTypeBadge(mealType: String, noCount: Int)-> some View{
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
                .background(noCount == 0 ? Constants.KODARIGray : Constants.KODARIBlue) // 0명이면 뱃지도 gray
                .cornerRadius(7)
            
            Text("\(mealTypeText)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 29.80556, height: 13, alignment: .center)
        }
    }
    
    // MARK: Memo Icon
    func noteAndWeatherIcon(useMemo: String) -> some View {
        ZStack {
            Image(systemName: "list.bullet.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(useMemo.count > 0 ? Constants.KODARIBlue : Constants.KODARIGray.opacity(0.15))
                .frame(width: 24, height: 24) // Circle과 동일한 크기
                .contentShape(Circle()) // 이미지의 컨텐츠 모양을 Circle로 설정
        }
    }
}

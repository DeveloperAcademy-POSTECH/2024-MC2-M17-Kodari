import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String // 검색한 메뉴 이름
    @State var mealsdata: [FoodData]
    
    let columns = [GridItem(.flexible())]
    
    // MARK: 인사이트 통계 변수들
    
    @State var weekdayMaxNum = 0 // 평일 최대 인원
    @State var weekdayMinNum = 0 // 평일 최소 인원
    @State var weekdayAvgNum = 0 // 평일 평균 인원
    
    @State var weekendMaxNum = 0 // 주말 최대 인원
    @State var weekendMinNum = 0 // 주말 최소 인원
    @State var weekendAvgNum = 0 // 주말 평균 인원
    
    @State var weekdayProgressValue: Float = 0.0
    @State var weekendProgressValue: Float = 0.0
    
    var body: some View {
        ZStack {
            Color(Constants.AppleGray)
                .edgesIgnoringSafeArea(.bottom)
            
            ScrollView {
                VStack{
                    VStack{
                        VStack{
                            
                            ResultsHeaderView(searchMenu: searchMenu)
                            
                            StatisticsView(
                                weekdayMaxNum: $weekdayMaxNum,
                                weekdayMinNum: $weekdayMinNum,
                                weekdayAvgNum: $weekdayAvgNum,
                                weekendMaxNum: $weekendMaxNum,
                                weekendMinNum: $weekendMinNum,
                                weekendAvgNum: $weekendAvgNum,
                                weekdayProgressValue: $weekdayProgressValue,
                                weekendProgressValue: $weekendProgressValue
                            )
                            
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
                setupProgressValue()
            }
        }
        .navigationTitle("검색결과")
    }
    
    // MARK: 메뉴 검색 필터
    private var filteredFoodData: [FoodData] {
        let searchLowercased = searchMenu.lowercased()
        
        // 필터링된 데이터를 date 기준으로 내림차순 정렬
        return mealsdata.filter { item in
            return item.menu1.lowercased().contains(searchLowercased) ||
            item.menu2.lowercased().contains(searchLowercased) ||
            item.menu3.lowercased().contains(searchLowercased) ||
            item.menu4.lowercased().contains(searchLowercased)
        }.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            
            if let firstDate = dateFormatter.date(from: first.date),
               let secondDate = dateFormatter.date(from: second.date) {
                return firstDate > secondDate // 내림차순 정렬
            }
            
            return false
        }
    }

    
    // MARK: Set Up ProgressValue Method
    func setupProgressValue() {
        if weekdayAvgNum == weekdayMaxNum && weekdayAvgNum == weekdayMinNum{
            weekdayProgressValue = 0.9
        } else {
            let weekdayPercentage = (Float(weekdayAvgNum) - Float(weekdayMinNum)) / (Float(weekdayMaxNum) - Float(weekdayMinNum))
            weekdayProgressValue = weekdayPercentage
        }
        
        if weekendAvgNum == weekendMaxNum && weekendAvgNum == weekendMinNum{
            weekendProgressValue = 0.9
        } else {
            let weekendPercentage = (Float(weekendAvgNum) - Float(weekendMinNum)) / (Float(weekendMaxNum) - Float(weekendMinNum))
            weekendProgressValue = weekendPercentage
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
            weekdayMaxNum = maxNum
            print("펑일 max: \(maxNum)")
        }
        
        let weekdayNonZeroArray = weekdayArray.filter { $0 != 0 }
        if let minNum = weekdayNonZeroArray.min() {
            weekdayMinNum = minNum
            print("평일 min: \(weekdayMinNum)")
        } else {
            weekdayMinNum = 0
            print("평일 min: \(weekdayMinNum)")
        }
        
        let weekdayTotal = weekdayNonZeroArray.reduce(0, +)
        print("평일 미입력 제외 Total: \(weekdayTotal)")
        let weekdayAverage = weekdayTotal / max(weekdayNonZeroArray.count, 1)
        weekdayAvgNum = weekdayAverage
       
        print("평일 avg: \(weekdayAvgNum)")
        
        // 주말 통계
        if let maxNum = weekendArray.max() {
            weekendMaxNum = maxNum
            print("주말 max: \(weekendMaxNum)")
        } else {
            weekendMaxNum = 0
            print("주말 max: \(weekendMaxNum)")
        }
        
        
        let weekendNonZeroArray = weekendArray.filter { $0 != 0 }
        if let minNum = weekendNonZeroArray.min() {
            weekendMinNum = minNum
            print("주말 min: \(weekendMinNum)")
        } else {
            weekendMinNum = 0
            print("주말 min: \(weekendMinNum)")
        }
        
        let weekendTotal = weekendNonZeroArray.reduce(0, +)
        print("주말 미입력 제외 Total: \(weekendTotal)")
        let weekendAverage = weekendTotal / max(weekendNonZeroArray.count, 1)
        weekendAvgNum = weekendAverage
        print("주말 avg: \(weekendAvgNum)")
    }
}

// MARK: ProgressBar 
struct WeekdayProgressBar: View {
    @Binding var weekdayprogress: Float
    var weekdayAvgNum: Int
    
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
                .fill(weekdayAvgNum == 0 ? Color.gray.opacity(0.3) :  Constants.KODARIBlue)
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

// 주말 ProgressBar
struct WeekendProgressBar: View {
    
    @Binding var weekendprogress: Float
    var weekendAvgNum: Int
    
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
                .fill(weekendAvgNum == 0 ? Color.gray.opacity(0.3) :  Constants.KODARIBlue)
                .rotationEffect(.degrees(54.5)) // 게이지 시작 지점 - Start Point
            
            VStack{
                Text("\(weekendAvgNum)")
                    .foregroundColor(Constants.KODARIBlue)
                    .font(Font.system(size: 20))
                    .fontWeight(.bold)
            }
        }
    }
}

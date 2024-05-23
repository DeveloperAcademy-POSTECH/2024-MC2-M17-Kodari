
import SwiftUI
import SwiftData

struct DateView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @StateObject private var menuAPIModel = MenuAPIModel()
    @State private var apiRequestTrue = true


    // SwiftData
    // @Query private var meals: [FoodData] // 선언 / //////
    @Environment(\.modelContext) var modelContext
    @State private var mealdata: [FoodData] = []
//    @State private var mealdataLoaded = false // 한번만 로드
    
    @Binding var selectedDate : Date //현재 날짜와 시간 가져오기
    private let calendar = Calendar.current //현재를 달력에 저장 /
    
    @State private var triangleLocation: CGPoint = .zero
    @State private var circleLocation: [Date: CGPoint] = [:] // 각 Circle의 위치를 저장
    
    @Query private var mealsdata: [FoodData]
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                monthView //날짜 뷰 (이름만 월뷰일뿐)
                
                Divider()
                
                trackPosition(of: Image(systemName: "arrowtriangle.down.fill"), in: $triangleLocation).frame(height: 15)
                
                ZStack{
                    dayView //요일 뷰
                    blurView //이쁘게 하려고 있는 블러 뷰
                }
                .frame(height: 30)
                .padding(.vertical, 20)
                
                VStack{
                    CellView(selectedDate: $selectedDate)
//                        .padding(.bottom, 75)
                }
            }
            
            .navigationBarItems(
                leading: NavigationLink(destination: CalendarView(currentDate: $selectedDate, mealsData: mealsdata)) {
                    Image(systemName: "calendar.badge.clock")
                },
                trailing: NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                }
            )
            
        }
        .onAppear {
            if isFirstLaunch {
                isFirstLaunch = false
                saveCSVData()
            }
            
            if apiRequestTrue{
                menuAPIModel.getMenus(foodDatas:mealsdata, modelContext: modelContext)
            }
            apiRequestTrue = false
        }
//        .onAppear {
//            if !mealdataLoaded {
//                saveCSVData()
//                mealdataLoaded = true
//            }
//        }
    }
    
    private func saveCSVData() {
        guard let url = Bundle.main.url(forResource: "MealData", withExtension: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let data = try String(contentsOf: url)
            let rows = data.components(separatedBy: "\n").dropFirst() // 첫 번째 줄은 헤더이므로 제외합니다.
            mealdata = rows.compactMap { row -> FoodData? in
                let components = row.components(separatedBy: ",")
                guard components.count >= 7 else { return nil }
                
                // 공백 제거 및 숫자로 변환 시도
                let trimmedNum = components[6].trimmingCharacters(in: .whitespacesAndNewlines)

                // 만약 공백이거나 값이 없으면 0으로 설정
                let convertnum = Int(trimmedNum) ?? 0
                
                let newData = FoodData(uniqueid: components[0], date: components[1], menu1: components[2], menu2: components[3], menu3: components[4], menu4: components[5], num: convertnum, memo:"")
                
                
                
                // SwiftData 모델에 저장
                modelContext.insert(newData)
                
                // 저장한 데이터 가져와서 mealdata 배열에 할당
                mealdata.append(newData)
                
                //return FoodData(uniqueid: components[0], date: components[1], menu1: components[2], menu2: components[3], menu3: components[4], menu4: components[5], num: components[6])
                return newData
            }
        } catch {
            print("Error reading CSV file:", error.localizedDescription)
        }
    }
    
    // MARK: - 월 표시 뷰
    private var monthView: some View { //날짜 뷰 (이름만 월뷰일뿐)
        return HStack(spacing: 0) {
            
            
            Spacer()
            
            Text("\(yearTitle(from: selectedDate))년 \(monthTitle(from: selectedDate))월 \(dayTitle(from: selectedDate))일 (\(day(from: selectedDate)))")
                .font(.title3)
                .bold()
            
            Spacer()
        }

    }
    
    // MARK: - 일자 표시 뷰
    @ViewBuilder
    private var dayView: some View {
        let todayDate = Date() //오늘 날짜 저장. (안바꿀거임)
        
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        let endDate = calendar.date(byAdding: .day, value: 7, to: todayDate)! // 일주일 후 날짜까지 표시

        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyHStack(spacing: 10) { // LazyHStack으로 변경
                    let components = dates(from: startDate, to: endDate)

                    ForEach(components, id: \.self) { date in
                        VStack {
                            Text(day(from: date))
                                .font(.caption)
                            
                            GeometryReader { geo in
                                Circle()
                                    .fill(Constants.CircleGray)
                                    .stroke(calendar.isDate(todayDate, equalTo: date, toGranularity: .day) ? Color.black : Color.clear) //원의 날짜가 오늘날짜와 같을 경우만 테두리 색 줌.
                                    .frame(width: 35, height: 35)
                                    .background(GeometryReader { geo -> Color in
                                        DispatchQueue.main.async { //우선순위를 가져가는 코드
                                            self.circleLocation[date] = geo.frame(in: .global).origin
                                            if abs(triangleLocation.x - circleLocation[date]!.x) < 25{
                                                selectedDate = date
                                                print("select:\(selectedDate)\n------------------------------")
                                                print("date:\(date)\n------------------------------")
                                            }
                                        }
                                        return Color.clear
                                    })
                            }
                            .frame(width: 35, height: 35)
                        }
                        .padding(5)
                        .id(date)
                        
                        // MARK: - 원을 탭했을 때 선택된 날짜로 스크롤
                        .onTapGesture {
                            withAnimation {
                                selectedDate = date
                                proxy.scrollTo(date, anchor: .center)
                            }
                        }
                    }
                }
                .frame(height: 60) // LazyHStack을 사용하기 때문에 ScrollView의 높이를 지정해야 함
                .padding(.trailing, 150)
                .padding(.leading, 160)
                
            }
            
            // MARK: - 앱이 처음 시작될 때 오늘 날짜로 스크롤
            .onAppear {
                if let today = getDatesInMonth(for: selectedDate).first(where: { calendar.isDateInToday($0) }) {
                    DispatchQueue.main.async {
                        proxy.scrollTo(today, anchor: .center)
                    }
                }
            }
            
        }
    }
    
    // MARK: - 두 날짜 사이의 모든 날짜를 반환하는 함수
    private func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = startDate

        while date <= endDate {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    
    // MARK: - 위치 추적 함수
    private func trackPosition(of view: some View, in binding: Binding<CGPoint>) -> some View {
        
            GeometryReader { geometry in
                view
                    .background(GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            binding.wrappedValue = geo.frame(in: .global).origin
                        }
                        return Color.clear
                    })
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        
    
    // MARK: - 오늘날짜 가운데로 오게하기!!
    func getDatesInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!

        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    
    // MARK: - 블러 뷰
    private var blurView: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.white.opacity(1),
                        Color.white.opacity(0)
                    ]
                ),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
            
            Spacer()
            
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.white.opacity(1),
                        Color.white.opacity(0)
                    ]
                ),
                startPoint: .trailing,
                endPoint: .leading
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
        }
    }
}

// MARK: - 로직
private extension DateView {
    /// 년 추출
    func yearTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 월 추출
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("M")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 일 추출
    func dayTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 월 변경
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(
            byAdding: .month,
            value: value,
            to: selectedDate
        ) else {
            return
        }
        
        selectedDate = date
    }
    
    /// 요일 추출
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E") //영어로 요일 표시 (간략하게)
        dateFormatter.locale = Locale(identifier: "ko_kr") //한글로 요일 표시
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    DateView()
//}

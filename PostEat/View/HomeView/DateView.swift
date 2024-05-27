
import SwiftUI
import SwiftData

struct DateView: View {
    
    // MARK: CSV & API
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true // CSV 불러왔는지 True, False로 UserDefaults 저장
    @State private var apiRequestTrue = true // API 요청 부울 변수
    @StateObject private var menuAPIModel = MenuAPIModel()
    
    // MARK: SwiftData
    @Environment(\.modelContext) var modelContext
    @State private var mealdata: [FoodData] = []
    @State private var recorddata: [recordCountData] = []
    @Query private var mealsdata: [FoodData]
    @Query var recordCountDatas: [recordCountData]
    
    // MARK: 캘린더
    @State var selectedDate = Date() //현재 날짜와 시간 가져오기
    private let calendar = Calendar.current //현재를 달력에 저장
    
    @State private var triangleLocation: CGPoint = .zero
    @State private var circleLocation: [Date: CGPoint] = [:] // 각 Circle의 위치를 저장
    
    // Hapti
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing: 0) {
                monthView //날짜 뷰 (이름만 월뷰일뿐)
                    .padding(.bottom)
                
                Divider()
                
                trackPosition(of: Image(systemName: "arrowtriangle.down.fill"), in: $triangleLocation)
                    .frame(height: 15)
                    .padding(.bottom, 5)
                
                ZStack{
                    DayView(
                        selectedDate: $selectedDate,
                        triangleLocation: $triangleLocation,
                        calendar: calendar,
                        recordCountDatas: recordCountDatas
                    )
                    BlurView() //이쁘게 하려고 있는 블러 뷰
                }
                .frame(height: 30)
                .padding(.vertical, 20)
                
                VStack{
                    CellView(selectedDate: $selectedDate)
                    
                }
            }
            .navigationBarItems(
                leading: NavigationLink(destination: CalendarView(month: selectedDate, onValueChange:  { newValue in
                    self.selectedDate = newValue
                })) {
                    Image(systemName: "calendar.badge.clock")
                },
                trailing: NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                })
        }
        .onAppear {
            if isFirstLaunch { // 사용자의 기기에서 첫 실행때만 동작
                CSVUtils.saveCSVData(mealdata: &mealdata, modelContext: modelContext)
                CSVUtils.saveRecordCountCSVData(recorddata: &recorddata, modelContext: modelContext)
                print("Run CSV File")
                isFirstLaunch = false
            }
            if apiRequestTrue{ // API 요청
                menuAPIModel.getMenus(foodDatas:mealsdata, modelContext: modelContext)
                print("RUN Request API ")
            }
            apiRequestTrue = false
        }
    }
    
    // MARK: - MonthView ( 월 표시 뷰 )
    private var monthView: some View { //날짜 뷰 (이름만 월뷰일뿐)
        return VStack(alignment: .center) {
            Text("\(DateUtils.yearTitle(from: selectedDate))년 \(DateUtils.monthTitle(from: selectedDate))월 \(DateUtils.dayTitle(from: selectedDate))일 (\(DateUtils.day(from: selectedDate)))")
                .font(.title3)
                .bold()
            
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
}

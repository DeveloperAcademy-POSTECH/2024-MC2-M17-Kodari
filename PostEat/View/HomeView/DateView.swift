
import SwiftUI
import SwiftData

struct DateView: View {
    
    // SwiftData
    // @Query private var meals: [FoodData] // 선언
    @Environment(\.modelContext) var modelContext
    @State private var mealdata: [FoodData] = []
    @State private var mealdataLoaded = false // 한번만 로드
    
    @State private var selectedDate = Date() //현재 날짜와 시간 가져오기
    private let calendar = Calendar.current //현재를 달력에 저장 /
    
    @State private var triangleLocate: CGPoint = .zero
    @State private var circleLocations: [Date: CGPoint] = [:] // 각 Circle의 위치를 저장
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                monthView //날짜 뷰 (이름만 월뷰일뿐)
                
                Divider()
                GeometryReader { geometry in //위치 추적
                    VStack {
                        Image(systemName: "arrowtriangle.down.fill")
                            .background(GeometryReader { geo -> Color in
                                
                                DispatchQueue.main.async {
                                    self.triangleLocate = geo.frame(in: .global).origin
                                    //triangleLocate 변수에 이미지 위치 저장.
                                }
                                return Color.clear
                            })
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height) //위치 가운데로.
                }
                .frame(height: 15)
                // Text("삼각형 위치: \(triangleLocate.x), \(triangleLocate.y)")
                
                ZStack{
                    dayView //요일 뷰
                    blurView //이쁘게 하려고 있는 블러 뷰
                }
                .frame(height: 30)
                .padding(.vertical, 20)
                
                VStack{
                    CellView()
                        .padding(.bottom, 75)
                }
            }
            
            .navigationBarItems(
                leading: NavigationLink(destination: CalendarView()) {
                    Image(systemName: "calendar.badge.clock")
                },
                trailing: NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                }
            )
            
        }
        .onAppear {
            if !mealdataLoaded {
                saveCSVData()
                mealdataLoaded = true
            }
        }
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
                guard components.count >= 6 else { return nil }
                
                let newData = FoodData(uniqueid: components[0], date: components[1], menu1: components[2], menu2: components[3], menu3: components[4], menu4: components[5], num: components[6])
                
                
                
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
    private var monthView: some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    changeMonth(-1)
                },
                label: {
                    Image(systemName: "chevron.left") // < 꺽쇠표시
                        .padding()
                }
            )
            HStack{
                Text("\(yearTitle(from: selectedDate))년 \(monthTitle(from: selectedDate))월 \(dayTitle(from: selectedDate))일 (\(day(from: selectedDate)))")
                    .font(.title3)
                    .bold()
            }
            Button(
                action: {
                    changeMonth(1)
                },
                label: {
                    Image(systemName: "chevron.right")// > 꺽쇠표시
                        .padding()
                }
            )
        }
        .background(Color.white)
    }
    
    // MARK: - 일자 표시 뷰
    @ViewBuilder
    private var dayView: some View {
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 10) {
                let components = (
                    0..<calendar.range(of: .day, in: .month, for: startDate)!.count)
                    .map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }
                
                ForEach(components, id: \.self) { date in
                    VStack {
                        Text(day(from: date))
                            .font(.caption)
                        
                        GeometryReader { geo in
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .fill(calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color(Constants.KODARIRed) : Color(Constants.KODARIGray))
                                .frame(width: geo.size.width, height: geo.size.height) // GeometryReader의 크기에 따라 원의 크기를 조정합니다.
                            // .background(GeometryReader { innerGeo -> Color in
                            //DispatchQueue.main.async {
                            //    self.circleLocations[date] = innerGeo.frame(in: .global).origin
                            //     }
                            // return Color.gray.opacity(0.3)
                            // })
                        }
                        .frame(width: 35, height: 35) // GeometryReader의 크기를 명시적으로 지정
                    }
                    .padding(5)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            
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

#Preview {
    DateView()
}

import SwiftUI
import SwiftData

struct DayView: View {
    
    @Binding var selectedDate: Date
    @State private var circleLocation: [Date: CGPoint] = [:]
    @Binding var triangleLocation: CGPoint
    let calendar: Calendar
    let recordCountDatas: [recordCountData]
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    //let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        let todayDate = Date() // 오늘 날짜 저장. (안바꿀거임)
        
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let endDate = calendar.date(byAdding: .day, value: 7, to: todayDate)! // 일주일 후 날짜까지 표시
        
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    let components = dates(from: startDate, to: endDate)
                    let allRecordData = recordCountDatas.filter { components.contains($0.date) }
                    let sortedAllRecordData = allRecordData.sorted { $0.date < $1.date }
                    
                    ForEach(sortedAllRecordData, id: \.self) { recordData in
                        let date = recordData.date
                        VStack {
                            Text(day(from: date))
                                .font(.caption)
                            
                            GeometryReader { geo in
                                Circle()
                                    .fill(date > Date() ? Constants.KODARIGray :(recordData.recordCount == 2 ? Constants.KODARIBlue : Constants.KODARIRed))
                                    .stroke(calendar.isDate(todayDate, equalTo: date, toGranularity: .day) ? Color.black : Color.clear)
                                    .frame(width: 35, height: 35)
                                    .background(GeometryReader { geo -> Color in
                                        DispatchQueue.main.async {
                                            self.circleLocation[date] = geo.frame(in: .global).origin
                                            if abs(triangleLocation.x - circleLocation[date]!.x) < 25 {
                                                if selectedDate != date {
                                                    selectionFeedbackGenerator.selectionChanged()
                                                    //impactFeedbackGenerator.impactOccurred()
                                                }
                                                selectedDate = date
                                            }
                                        }
                                        return Color.clear
                                    })
                            }
                            .frame(width: 35, height: 35)
                        }
                        .padding(5)
                        .id(date)
                        .onTapGesture {
                            withAnimation {
                                selectedDate = date
                                proxy.scrollTo(date, anchor: .center)
                               
                            }
                        }
                    }
                }
                .frame(height: 60)
                .padding(.trailing, 150)
                .padding(.leading, 160)
            }
            .onAppear {
                if let today = getDatesInMonth(for: selectedDate).first(where: { calendar.isDateInToday($0) }) {
                    DispatchQueue.main.async {
                        proxy.scrollTo(today, anchor: .center)
                    }
                }
            }
        }
    }
    
    private func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = startDate
        
        while date <= endDate {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    
    private func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    private func getDatesInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
}

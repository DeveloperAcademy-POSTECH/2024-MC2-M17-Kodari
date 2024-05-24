//
//  CalendarView2.swift
//  calendar
//
//  Created by 장유진 on 5/22/24.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @Environment(\.presentationMode) var presentationMode
    
    var onValueChange: (Date) -> Void
    init(month: Date, onValueChange: @escaping (Date) -> Void) {
        self._month = State(initialValue: month)
        self.onValueChange = onValueChange
    }
    
    @Query var recordCountDatas: [recordCountData]
    
    var body: some View {
        let daysInMonth: Int = numberOfDays(in: month) //월이 가진 날짜 수
        let firstWeekday: Int = firstWeekdayOfMonth(in: month)-1 //해당 월의 첫 날짜가 어떤 요일로 int 값을 갖는지
        
        //        let nowMonth = formatDate(.dateToString(month))?.split(separator: ":")[1]
        //        let monthRecordData = recordCountData.filter{formatDate(.dateToString($0.date))?.split(separator: ":")[1] == nowMonth}
        
        VStack {
            HeaderView
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                        if index < firstWeekday {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.clear)
                        } else {
                            let date = getDate(for: index - firstWeekday)
                            let day = index - firstWeekday + 1
                            let dayRecordCountData = recordCountDatas.filter{$0.date == date}
                            
                            VStack {
                                ZStack {
                                    if month == date {
                                        Circle()
                                            .fill(Color.gray.opacity(0.4))
                                    }
                                    Text(String(day))
                                }
                                
                                if dayRecordCountData.count != 0{
                                    if dayRecordCountData[0].recordCount == 3{
                                        Circle()
                                            .frame(width:5)
                                            .foregroundStyle(Constants.KODARIBlue)
                                    } else{
                                        Circle()
                                            .frame(width:5)
                                            .foregroundStyle(Constants.KODARIRed)
                                    }
                                }
                            }
                            .onTapGesture {
                                month = date
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
        .navigationBarTitle("달력 보기", displayMode: .inline)
        .navigationBarItems(leading: Button(action:{
            onValueChange(month)
            self.presentationMode.wrappedValue.dismiss() }) {
            HStack{
                Image(systemName: "chevron.left")
                Text("Home")
            }
        })
    }
    
    //월, 연도, 요일 표기
    private var HeaderView: some View {
        VStack{
            HStack {
                Text(formatDate(.dateToString(month)) ?? "")
                Spacer()
            } .padding()
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) {symbol in Text(symbol)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    //실제 일자별로
    //    private var CalendarGridView: some View {
    //
    //
    //
    //        return
    //    }
}

extension CalendarView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = " yyyy MM"
        return formatter
    } ()
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

private extension CalendarView {
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    //해당 월의 첫 날짜가 갖는 해당 주의 몇 번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value:value, to: month) {
            self.month = newMonth
        }
    }
}

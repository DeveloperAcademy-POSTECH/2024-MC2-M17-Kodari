//
//  CalendarView2.swift
//  calendar
//
//  Created by 장유진 on 5/22/24.
//

import SwiftUI

struct CalendarView: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @State var clickedDates: Set<Date> = []
    @State var when: Int
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView
                CalendarGridView
                
            } .padding()
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
                ) .navigationTitle("달력보기")
                .navigationBarTitleDisplayMode(.inline)
               
        }
    }
    //월, 연도, 요일 표기
    private var HeaderView: some View {
        VStack{
            HStack {
                Text(month, formatter: Self.dateFormatter)
                Text("\(when)")
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
    private var CalendarGridView: some View {
        
        let daysInMonth: Int = numberOfDays(in: month) //월이 가진 날짜 수
        let firstWeekday: Int = firstWeekdayOfMonth(in: month)-1 //해당 월의 첫 날짜가 어떤 요일로 int 값을 갖는지
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        //                        RoundedRectangle(cornerRadius: 5)
                        //                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        //let clicked = clickedDates.contains(date)
                        
                        CalendarCellView(day: day, clicked: false, when: when) // clicked: clicked, cellDate: date
                            .onTapGesture {
                                when = day
                            }
                    }
                }
            }
        }
    }
}

private struct CalendarCellView: View {
    var day: Int
    var clicked: Bool = false
    var when: Int
    //var cellDate: Date
    
    //init(day:Int, clicked: Bool, cellDate: Date) {
    init(day:Int, clicked: Bool, when: Int) {
        self.day = day
        self.clicked = clicked
        self.when = when
        //self.cellDate = cellDate
    }
    
    var body: some View {
        VStack {
            //Button {
            //    month = cellDate
            //} label: {
//            RoundedRectangle(cornerRadius: 5)
//                .opacity(0)
//                .overlay(Text(String(day)))
//            A()
                ZStack {
                    if when == day {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                    }
                    Text(String(day))
                }
        }
        
        //if clicked {
        //    Text("Click")
        //    .font(.caption)
        //    .foregroundColor(.blue)
        //}
    }
}
//
//struct A: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 5)
//                .opacity(0)
//                .overlay(Text(String(day)))
//        }
//    }
//}


extension CalendarView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = " yyyy MM"
        return formatter
    } ()
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

//
//#Preview {
//    CalendarView(month: Date(), when: 1)
//}


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


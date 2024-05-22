//
//  CalendarView2.swift
//  calendar
//
//  Created by 장유진 on 5/22/24.
//
//
//  CustomDatePicker.swift
//  ElegantTaskApp
//
//  Created by 변준섭 on 5/19/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    var mealsData: [FoodData]
    // Month update on arrow button click
    @State var currentMonth: Int = 0
    let dateFormatter = DateFormatter()

    
    var body: some View {
        VStack(spacing: 35){
            // 필터링 및 변환
            let emptyMealsDates = mealsData.filter { meal in
                let components = meal.date.split(separator: ":")
                return components[1] == extraDate()[1] && meal.num == 0
            }.compactMap { meal in
                dateFormatter.date(from: meal.date)
            }
            // 중복 제거
            let uniqueEmptyMealsDates = Array(Set(emptyMealsDates))
            
            Button(action:{
                print(emptyMealsDates)
            }){
                Circle()
                    .frame(width:100, height:20)
            }
            
            // Days...
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack(spacing: 20){
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(extraDate()[0])
                    
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button{
                    withAnimation{
                        currentMonth -= 1
                        currentDate = getCurrentMonth()

                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button{
                    withAnimation{
                        currentMonth += 1
                        currentDate = getCurrentMonth()

                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            // Day View...
            
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates....
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15){
                
                ForEach(extractDate()){ value in
                    CardView(value: value, emptyDays: uniqueEmptyMealsDates)
                }
            }
            
        }
        .onAppear{
            dateFormatter.dateFormat = "yyyy:MM:dd"
        }
        
        .onChange(of: currentMonth) { newValue in
            // updating Month...
//            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue, emptyDays: [Date])-> some View{
        VStack{
            
            if value.day != -1{
                Button(action:{
                    currentDate = value.date
                    print(emptyDays)
                }){
                    
                    VStack{
                        ZStack{
                            if currentDate == value.date{
                                Circle()
                                    .frame(width:40, height:40)
                                    .foregroundStyle(Constants.KODARIBlue)
                                    .opacity(0.7)
                                    .padding(0)
                            }
                            Text("\(value.day)") // value.date 를 찍어봐야 함 이게 date 형
                            // 그러면, value.date 에 해당하는 날짜를 swiftdata 에서 가져온 후애, num 에서 0이 몇개인지 센다.
                            // 0 이 0개이면 파란불, 나머진 빨간불
                                .font(.title3.bold())
                                .foregroundStyle(Color.black)
                        }.frame(height:40)
                        Spacer()
                        if emptyDays.contains(value.date) {
                            Circle()
                                .frame(width:5)
                                .foregroundStyle(Color.red)
                        } else{
                            Circle()
                                .frame(width:5)
                                .foregroundStyle(Color.blue)
                        }
                        
                        
                    }.frame(height:55)
                    
                }
                
            }
        }
    }
    
    // extrating Year And Month for display...
    func extraDate()-> [String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()-> Date{
        let calendar = Calendar.current
        
        // Getting Current Month Date....
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue]{
        
        let calendar = Calendar.current
        
        // Getting Current Month Date....
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        //adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}


// Extending Date to get Current Month Dates...
extension Date{
    
    func getAllDates() -> [Date]{
        
        let calendar = Calendar.current
        
        // getting start Date...
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in:.month, for:self)!
        
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

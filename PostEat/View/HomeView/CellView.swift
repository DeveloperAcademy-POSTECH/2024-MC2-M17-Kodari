
import SwiftUI
import SwiftData

struct CellView: View {
    let columns = [GridItem(.flexible())]
    let eatingTime: [Array] = [["조식", "07:30 ~ 09:30"], ["중식", "11:30 ~ 13:30"], ["석식", "17:30 ~ 19:00"]]
    
    let calendar = Calendar.current
    
    @State var recordModalShowing : Bool = false
    @State var selectedIndex: Int? = 0 // 선택된 인덱스를 추적하는 상태 변수
    
    @Binding var selectedDate : Date //현재 날짜와 시간 가져오기
    
    @Environment(\.modelContext) var modelContext
    @Query() private var mealsdata: [FoodData]
    
    var body: some View {
        ZStack{
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255).ignoresSafeArea()
            
            let selectedMealsData = mealsdata.filter{$0.date == formatDate(.dateToString(selectedDate))}
            //print(selectedMealsData.count)
            if selectedMealsData.count != 0{
                //            if selectedMealsData {
                //                LazyVGrid(columns: columns) {
                ScrollView{
                    ForEach(eatingTime.indices, id: \.self) { index in
                        Button(action:{
                            DispatchQueue.main.async{
                                selectedIndex = index
                                recordModalShowing.toggle()
                            }
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 360, height: selectedMealsData[index].num != 0 ? 163 : 206)
                                    .foregroundStyle(Color.white)
                                
                                VStack{
                                    HStack{
                                        VStack{
                                            HStack{
                                                // 조식 / 중식 / 석식
                                                Text("\(eatingTime[index][0])")
                                                    .font(.system(size: 15))
                                                    .bold()
                                                    .foregroundStyle(Color.black)
                                                    .frame(width:30)
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 9)
                                                        .frame(width:86, height:20)
                                                        .foregroundStyle(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                                    // 식사 가능 시간
                                                    Text("\(eatingTime[index][1])")
                                                        .font(.system(size:11))
                                                        .foregroundStyle(Color.black)
                                                }
                                                Spacer()
                                            }
                                            ForEach([selectedMealsData[index].menu1,
                                                     selectedMealsData[index].menu2,
                                                     selectedMealsData[index].menu3,
                                                     selectedMealsData[index].menu4
                                                    ], id: \.self) { menu in
                                                HStack{
                                                    Text("\(menu)")
                                                        .font(.system(size:15))
                                                        .padding(0.5)
                                                        .foregroundStyle(Color.black)
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .padding(.leading, 22)
                                        
                                        VStack{
                                            HStack{
                                                Spacer()
                                                if selectedMealsData[index].num != 0 {
                                                    Image(systemName:"checkmark.circle.fill")
                                                        .foregroundStyle(Color(Constants.KODARIBlue))
                                                        .padding(.top, 15)
                                                } else{
                                                    Image(systemName:"clock.badge.fill")
                                                        .foregroundStyle(Color(Constants.KODARIRed))
                                                        .padding(.top, 15)
                                                }
                                            }
                                            Spacer()
                                            HStack{
                                                Spacer()
                                                if selectedMealsData[index].num != 0{
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 9)
                                                            .frame(width:65, height:20)
                                                            .foregroundStyle(Color(Constants.KODARIBlue))
                                                        Text("\(selectedMealsData[index].num)명 방문")
                                                            .font(.system(size:11))
                                                            .bold()
                                                            .foregroundStyle(Color.white)
                                                    }
                                                    .padding(.bottom, 15)
                                                }
                                            }
                                        }
                                        .padding(.trailing, 22)
                                    }
                                    
                                    if selectedMealsData[index].num == 0 {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 12)
                                                .frame(width:319, height:35.5)
                                                .foregroundStyle(Color(Constants.KODARIRed))
                                            Text("기록하기")
                                                .font(.system(size:18))
                                                .bold()
                                                .foregroundStyle(Color.white)
                                        }.padding(.bottom, 15)
                                    }
                                }
                            }
                            .frame(width: 360, height: selectedMealsData[index].num != 0 ? 163 : 206)
                        }
                        .sheet(isPresented: $recordModalShowing) {
                            if let selectedIndex = selectedIndex {
                                RecordView(recordModalShowing: $recordModalShowing, mealData: selectedMealsData[selectedIndex])
                                    .presentationDetents([.height(500), .large])
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}


enum DateFormat {
    case stringToDate(String)
    case dateToString(Date)
}

func formatDate(_ input: DateFormat) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy:MM:dd"
    
    switch input {
    case .stringToDate(let dateString):
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return dateFormatter.string(from: date)
    case .dateToString(let date):
        return dateFormatter.string(from: date)
    }
}

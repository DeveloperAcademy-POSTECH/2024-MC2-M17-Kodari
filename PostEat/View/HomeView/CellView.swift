
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
    @Query var recordCountDatas: [recordCountData]

    var body: some View {
        ZStack{
            Color(Constants.AppleGray)
                .edgesIgnoringSafeArea(.bottom)
            
            let RawselectedMealsData = (mealsdata.filter{$0.date == formatDate(.dateToString(selectedDate))})
            let selectedMealsData = RawselectedMealsData.sorted{ $0.uniqueid > $1.uniqueid}
            let selectedrecordData = recordCountDatas.filter{$0.date == selectedDate}
            
            if selectedMealsData.count != 0{
                ScrollView{
                    ForEach(selectedMealsData.indices, id: \.self) { index in
                        Button(action:{
                            DispatchQueue.main.async{
                                selectedIndex = index
                                recordModalShowing.toggle()
                            }
                        }){
                            VStack{
                                HStack{
                                    VStack{
                                        if selectedMealsData[index].num != 0 {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .foregroundStyle(Constants.KODARIBlue)
                                                .frame(width: 25, height: 225)
                                            Text("\(selectedMealsData[index].num)명")
                                                .font(.system(size: 17))
                                                .bold()
                                                .foregroundStyle(Constants.KODARIBlue)
                                        } else {
                                            Image(systemName: "clock.badge.checkmark.fill")
                                                .resizable()
                                                .foregroundStyle(Constants.KODARIRed)
                                                .frame(width: 25, height: 25)
                                            Text("기록필요")
                                                .bold()
                                                .font(.system(size: 14))
                                                .foregroundStyle(Constants.KODARIRed)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                        .padding(.vertical, 20)
                                    
                                    VStack(alignment: .leading, content: {
                                        Text("\(eatingTime[index][0])")
                                            .font(.system(size:14.3))
                                            .bold()
                                            .foregroundStyle(Color.black)
                                            .padding(.bottom, 1)
                                        Text("\(selectedMealsData[index].menu1)")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size:15))
                                        Text("\(selectedMealsData[index].menu2)")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size:15))
                                        Text("\(selectedMealsData[index].menu3)")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size:15))
                                        if selectedMealsData[index].menu4 != ""{
                                            Text("\(selectedMealsData[index].menu4)")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size:15))
                                        }
                                    })
                                    .padding(.leading, 14)
                                    
                                    Spacer()
                                    
                                    VStack{
                                        if selectedMealsData[index].num != 0 {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .foregroundStyle(Constants.KODARIBlue)
                                                .frame(width: 25, height:25)
                                        } else {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .foregroundStyle(Constants.KODARIRed)
                                                .frame(width: 25, height: 25)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(height:  137)
                            .background(.white)
                            .cornerRadius(20)
                            .padding(.horizontal) // Cell 수평 간격
                            .padding(.top, 5) // Cell 3개 사이 간격
                            .sheet(isPresented: $recordModalShowing) {
                                if let selectedIndex = selectedIndex {
                                    RecordView(recordModalShowing: $recordModalShowing, selectedDate: $selectedDate, mealData: selectedMealsData[selectedIndex], selectedrecordData: selectedrecordData[0])
                                        .presentationDetents([.height(500), .large])
                                        .presentationCornerRadius(25)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
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

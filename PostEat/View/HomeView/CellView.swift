
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
            
            let RawselectedMealsData = (mealsdata.filter{$0.date == formatDate(.dateToString(selectedDate))})
            let selectedMealsData = RawselectedMealsData.sorted{ $0.uniqueid > $1.uniqueid}
            
            if selectedMealsData.count != 0{
                ScrollView{
                    ForEach(selectedMealsData.indices, id: \.self) { index in
                        Button(action:{
                            DispatchQueue.main.async{
                                selectedIndex = index
                                recordModalShowing.toggle()
                            }
                        }){
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(height:139)
                                    .foregroundStyle(Color.white)
                                HStack{
                                    VStack{
                                        if selectedMealsData[index].num != 0 {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(Constants.KODARIBlue)
                                                .frame(width:25, height:25)
                                            Text("\(selectedMealsData[index].num)명")
                                                .font(.system(size:17))
                                                .bold()
                                                .foregroundStyle(Constants.KODARIBlue)
                                        } else if selectedMealsData[index].date.toDate()! < Date(){
                                            Image(systemName: "clock.badge.checkmark.fill")
                                                .foregroundStyle(Constants.KODARIRed)
                                                .frame(width:25, height:25)
                                            Text("기록필요")
                                                .font(.system(size:14))
                                                .bold()
                                                .foregroundStyle(Constants.KODARIRed)
                                        } else{
                                            Image(systemName: "clock.badge.checkmark.fill")
                                                .foregroundStyle(Constants.KODARIGray)
                                                .frame(width:25, height:25)
                                            Text("기록필요")
                                                .font(.system(size:14))
                                                .bold()
                                                .foregroundStyle(Constants.KODARIGray)
                                        }
                                    }.frame(width:83).padding(.leading, 5)
                                    
                                    Divider().padding(.vertical, 25)
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
                                    }).padding(.leading, 14)
                                    Spacer()
                                    VStack{
                                        if selectedMealsData[index].num != 0 {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundStyle(Constants.KODARIBlue)
                                                .frame(width:25, height:25)
                                        } else {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundStyle(Constants.KODARIRed)
                                                .frame(width:25, height:25)
                                        }
                                    }.padding(.trailing, 17)
                                }
                                //
                                //                                    VStack{
                                //                                        HStack{
                                //                                            VStack{
                                //                                                HStack{
                                //                                                    // 조식 / 중식 / 석식
                                //                                                    Text("\(eatingTime[index][0])")
                                //                                                        .font(.system(size: 15))
                                //                                                        .bold()
                                //                                                        .foregroundStyle(Color.black)
                                //                                                        .frame(width:30)
                                //                                                    ZStack{
                                //                                                        RoundedRectangle(cornerRadius: 9)
                                //                                                            .frame(width:86, height:20)
                                //                                                            .foregroundStyle(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                //                                                        // 식사 가능 시간
                                //                                                        Text("\(eatingTime[index][1])")
                                //                                                            .font(.system(size:11))
                                //                                                            .foregroundStyle(Color.black)
                                //                                                    }
                                //                                                    Spacer()
                                //                                                }
                                //                                                ForEach([selectedMealsData[index].menu1,
                                //                                                         selectedMealsData[index].menu2,
                                //                                                         selectedMealsData[index].menu3,
                                //                                                         selectedMealsData[index].menu4
                                //                                                        ], id: \.self) { menu in
                                //                                                    HStack{
                                //                                                        Text("\(menu)")
                                //                                                            .font(.system(size:15))
                                //                                                            .padding(0.5)
                                //                                                            .foregroundStyle(Color.black)
                                //                                                        Spacer()
                                //                                                    }
                                //                                                }
                                //                                            }
                                //                                            .padding(.leading, 22)
                                //
                                //                                            VStack{
                                //                                                HStack{
                                //                                                    Spacer()
                                //                                                    if selectedMealsData[index].num != 0 {
                                //                                                        Image(systemName:"checkmark.circle.fill")
                                //                                                            .foregroundStyle(Color(Constants.KODARIBlue))
                                //                                                            .padding(.top, 15)
                                //                                                    } else{
                                //                                                        Image(systemName:"clock.badge.fill")
                                //                                                            .foregroundStyle(Color(Constants.KODARIRed))
                                //                                                            .padding(.top, 15)
                                //                                                    }
                                //                                                }
                                //                                                Spacer()
                                //                                                HStack{
                                //                                                    Spacer()
                                //                                                    if selectedMealsData[index].num != 0{
                                //                                                        ZStack{
                                //                                                            RoundedRectangle(cornerRadius: 9)
                                //                                                                .frame(width:65, height:20)
                                //                                                                .foregroundStyle(Color(Constants.KODARIBlue))
                                //                                                            Text("\(selectedMealsData[index].num)명 방문")
                                //                                                                .font(.system(size:11))
                                //                                                                .bold()
                                //                                                                .foregroundStyle(Color.white)
                                //                                                        }
                                //                                                        .padding(.bottom, 15)
                                //                                                    }
                                //                                                }
                                //                                            }
                                //                                            .padding(.trailing, 22)
                                //                                        }
                                //
                                //                                        if selectedMealsData[index].num == 0 {
                                //                                            ZStack{
                                //                                                RoundedRectangle(cornerRadius: 12)
                                //                                                    .frame(height:35.5)
                                //                                                    .foregroundStyle(Color(Constants.KODARIRed))
                                //                                                Text("기록하기")
                                //                                                    .font(.system(size:18))
                                //                                                    .bold()
                                //                                                    .foregroundStyle(Color.white)
                                //                                            }.padding(.bottom, 15)
                                //                                                .padding(.horizontal, 20.5)
                                //                                        }
                                //                                    }
                            }
                            
                            .padding(.horizontal, 16.5)
                            
                            
                        }
                        .sheet(isPresented: $recordModalShowing) {
                            if let selectedIndex = selectedIndex {
                                RecordView(recordModalShowing: $recordModalShowing, selectedDate: $selectedDate, mealData: selectedMealsData[selectedIndex])
                                    .presentationDetents([.height(500), .large])
                                    .presentationCornerRadius(25)
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
extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


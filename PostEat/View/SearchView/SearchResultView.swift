import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String
    @State var mealsdata: [FoodData]
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            
            Color(Constants.AppleGray)
            ScrollView {
                
                VStack{
                    VStack{
                        HStack(spacing:0){
                            Text("\(searchMenu)")
                                .foregroundColor(Color(Constants.POSTECHRed))
                                .font(.system(size: 22))
                                .bold()
                            Text(" 통계 결과")
                                .font(.system(size: 22))
                                .bold()
                            Spacer()
                        }
                        .padding(18)
                        HStack(spacing:0){
                            Text("\(searchMenu)")
                                .foregroundColor(Color(Constants.POSTECHRed))
                                .font(.system(size: 22))
                                .bold()
                            Text(" 그래프 정보")
                                .font(.system(size: 22))
                                .bold()
                            Spacer()
                        }
                        .padding(18)
                    }
                    .background(.white)
                    .cornerRadius(15)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredFoodData, id: \.id) { item in
                            CustomCellView(foodData: item)
                               
                        }
                    }
                    .background(.clear)
                    .cornerRadius(15)
                    .padding(.top)
                }
                .padding(18)
            }
        }
        .navigationTitle("검색결과")
    }
    
    private var filteredFoodData: [FoodData] {
        return mealsdata.filter { item in
            let searchLowercased = searchMenu.lowercased()
            return item.menu1.lowercased().contains(searchLowercased) ||
            item.menu2.lowercased().contains(searchLowercased) ||
            item.menu3.lowercased().contains(searchLowercased) ||
            item.menu4.lowercased().contains(searchLowercased)
        }
    }
}

// MARK: Cell View
struct CustomCellView: View {
    
    let foodData: FoodData
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 날짜 형식 설정
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                counterBadge(count: foodData.num)
                Spacer()
                dateBadge(day: foodData.date)
                mealTypeBadge(mealType: foodData.uniqueid)
                
            }
            .padding(.top, 10)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            HStack {
                mealContents(menu1: foodData.menu1, menu2: foodData.menu2, menu3: foodData.menu3, menu4: foodData.menu4)
                Spacer()
//                noteAndWeatherIcon
//                    .padding(.top, 60)
//                    .padding(.leading, 50)
                
            }
            .padding(EdgeInsets(top: 2, leading: 15, bottom: 10, trailing: 30))
        }
        .frame(maxWidth: .infinity)
        //.padding(15)
        .background(Color.white)
        .cornerRadius(10)
    }

    // MARK: 식수
    func counterBadge(count: String) -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width:80, height:22)
                .background(Constants.KODARIBlue)
                .cornerRadius(9)
            
            Text("\(String(count.dropLast()).count != 0 ? String(count.dropLast()) + "명 방문" : "미입력")")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.White)
                .frame(width: 80, height: 11, alignment: .center)
        }
    }
    
    // MARK: 날짜
    func dateBadge(day: String) -> some View {
        
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 130, height: 22)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("\(parseDateString(day))")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 110, height: 13, alignment: .center)
        }
    }
    
    func parseDateString(_ dateString: String) -> String {
        let components = dateString.split(separator: ":")
        if components.count == 3 {
            let year = components[0]
            let month = components[1]
            let day = components[2]
            return "\(year)년 \(month)월 \(day)일"
        } else {
            return dateString
        }
    }
    
    // MARK: 식단
    func mealContents(menu1: String, menu2: String, menu3: String, menu4: String)-> some View{
        
        VStack(alignment: .leading, spacing: 0.5){
            Text(menu1)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                
                .padding(2)
            Text(menu2)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
                
                .padding(2)
            Text(menu3)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
               
                .padding(2)
            Text(menu4)
                .font( Font.custom("Apple SD Gothic Neo", size: 15) )
             
                .padding(2)
        }
      
    }
    
    // MARK: Meal Type
    func mealTypeBadge(mealType: String)-> some View{
        let mealTypeText: String
        
        // uniqueid의 마지막 문자를 확인하여 조식, 중식, 석식 텍스트 설정
        switch mealType.last {
        case "M":
            mealTypeText = "조식"
        case "L":
            mealTypeText = "중식"
        case "D":
            mealTypeText = "석식"
        default:
            mealTypeText = "알 수 없음"
        }
        
        return ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 37, height: 22)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(6)
            
            Text("\(mealTypeText)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                .frame(width: 29.80556, height: 13, alignment: .center)
        }
    }
    
    
//    var noteAndWeatherIcon: some View{
//        
//        HStack{
//            Image(systemName:"chart.line.uptrend.xyaxis.circle.fill")
//                .font(.system(size: 20))
//                .foregroundColor(Constants.KODARIGray)
//                .frame(width: 15,alignment: .leading)
//                .padding()
//            
//            Image(systemName:"cloud.heavyrain.fill")
//                .font(.system(size: 20))
//                .foregroundColor(Constants.KODARIGray)
//                .frame(width: 15,alignment: .trailing)
//            
//        }
//    }
}


#Preview {
    SearchResultsView(searchMenu: "서치메뉴", mealsdata: [
        FoodData(uniqueid: "1", date: "2024-05-20", menu1: "Menu 1", menu2: "Menu 2", menu3: "Menu 3", menu4: "Menu 4", num: "123"),
        FoodData(uniqueid: "2", date: "2024-05-21", menu1: "Menu A", menu2: "Menu B", menu3: "Menu C", menu4: "Menu D", num: "123")
    ])
}

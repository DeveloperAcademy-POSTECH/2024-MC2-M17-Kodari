
import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String
    
    @State var mealsdata: [FoodData]
    
    var body: some View {
        
        ZStack{
            Color(Constants.AppleGray)
            
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
                    .padding(22)
                    Spacer()
                }
                .background(.white)
                .cornerRadius(15)
                .padding(18)
                
                List(filteredFoodData, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text("uniqueid: \(item.uniqueid)")
                        Text("date: \(item.date)")
                        Text("menu 1: \(item.menu1)")
                        Text("menu 2: \(item.menu2)")
                        Text("menu 3: \(item.menu3)")
                        Text("menu 4: \(item.menu4)")
                        Text("num: \(item.num)")
                    }
                }
            }
        }.navigationTitle("검색결과")
    }
    
    private var filteredFoodData: [FoodData] {
        return mealsdata.filter { item in
            let searchLowercased = searchMenu
            return item.menu1.lowercased().contains(searchLowercased) ||
            item.menu2.lowercased().contains(searchLowercased) ||
            item.menu3.lowercased().contains(searchLowercased) ||
            item.menu4.lowercased().contains(searchLowercased)
        }
    }
    
}

#Preview {
    SearchResultsView(searchMenu: "서치메뉴", mealsdata: [
        FoodData(uniqueid: "1", date: "2024-05-20", menu1: "Menu 1", menu2: "Menu 2", menu3: "Menu 3", menu4: "Menu 4", num: "123"),
        FoodData(uniqueid: "2", date: "2024-05-21", menu1: "Menu A", menu2: "Menu B", menu3: "Menu C", menu4: "Menu D", num: "123")
    ])
}

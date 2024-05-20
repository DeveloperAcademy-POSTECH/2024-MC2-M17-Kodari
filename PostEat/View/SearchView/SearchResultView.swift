
import SwiftUI
import SwiftData

struct SearchResultsView: View {
    
    @State var searchMenu: String // 바인딩으로 연결해야함
    
    @State var mealsdata: [FoodData] // @State 제거
    // @Query private var mealsdata: [FoodData]
    
    var body: some View {
        ZStack{
            Color(hex: "F3F2F8")
            
            VStack{
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
                
                
            }
        }.navigationTitle("검색결과")
            // .toolbarRole(.editor)
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

// Color -> Hex 값 적용
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

//#Preview {
//    SearchResultsView()
//}

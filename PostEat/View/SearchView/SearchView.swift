import SwiftUI
import SwiftData

struct SearchView: View {
    
    @State private var searchText: String = ""
    @State var editText: Bool = false //검색창 지우기 할때 쓰는 변수
    @Query private var mealsdata: [FoodData] // 검색어 메뉴 목록 ( SwiftData에 저장되어있는 메뉴들 )
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    TextField("메뉴를 검색하세요.", text: $searchText)
                        .padding(8)
                        .padding(.horizontal,10)
                        .background(Constants.AppleGray)
                        .frame(width: 360)
                        .cornerRadius(10)
                        .overlay(
                            HStack{
                                Spacer()
                                if self.editText {
                                    Button{ // x버튼을 누르면 입력된 값들 취소하고 키입력 이벤트 종료.
                                        self.editText = false
                                        searchText = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) //키보드에서 입력을 끝내게 하는 코드
                                    } label: {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            })
                        .onTapGesture {
                            self.editText = true
                        }
                        .padding(.top, 10)
                    
                    if !searchText.isEmpty{
                        List {
                            ForEach(searchResults, id: \.id) { meal in // Set은 순서가 없기 때문에 못넣고 배열을 넣어야 함
                                Group { // NavigationLink 4개인 이유 : menu1 ~ menu4를 각각 searchMenu 변수로 넣기 위함
                                    if meal.menu1.contains(searchText) {
                                        NavigationLink(destination: SearchResultsView(searchMenu: meal.menu1, mealsdata: mealsdata)) {
                                            HighlightedText(text: meal.menu1, highlight: searchText)
                                        }
                                    }
                                    if meal.menu2.contains(searchText) {
                                        NavigationLink(destination: SearchResultsView(searchMenu: meal.menu2, mealsdata: mealsdata)) {
                                            HighlightedText(text: meal.menu2, highlight: searchText)
                                        }
                                    }
                                    if meal.menu3.contains(searchText) {
                                        NavigationLink(destination: SearchResultsView(searchMenu: meal.menu3, mealsdata: mealsdata)) {
                                            HighlightedText(text: meal.menu3, highlight: searchText)
                                        }
                                    }
                                    if meal.menu4.contains(searchText) {
                                        NavigationLink(destination: SearchResultsView(searchMenu: meal.menu4, mealsdata: mealsdata)) {
                                            HighlightedText(text: meal.menu4, highlight: searchText)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    } else {
                        VStack{
                            Image("ponix")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .padding(.top,200)
                                .padding(.bottom,20)
                            Text("무엇을 찾아드릴까요?")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
                .navigationTitle("검색하기")
                .toolbarRole(.editor)
            }
        }
    }
    
    // MARK: 검색 필터
    var searchResults: [FoodData] {
        if searchText.isEmpty {
            return mealsdata
        } else {
            var uniqueResults: [FoodData] = []
            var addedMenus: Set<String> = Set() // 중복되는 메뉴 제거
            
            // Set에 없으면 Array에 넣고 Array Return
            for meal in mealsdata {
                if meal.menu1.contains(searchText) && !addedMenus.contains(meal.menu1) {
                    uniqueResults.append(meal)
                    addedMenus.insert(meal.menu1)
                } else if meal.menu2.contains(searchText) && !addedMenus.contains(meal.menu2) {
                    uniqueResults.append(meal)
                    addedMenus.insert(meal.menu2)
                } else if meal.menu3.contains(searchText) && !addedMenus.contains(meal.menu3) {
                    uniqueResults.append(meal)
                    addedMenus.insert(meal.menu3)
                } else if meal.menu4.contains(searchText) && !addedMenus.contains(meal.menu4) {
                    uniqueResults.append(meal)
                    addedMenus.insert(meal.menu4)
                }
            }
            return uniqueResults
        }
    }
}

// MARK: 하이라이트 텍스트
struct HighlightedText: View {
    
    let text: String
    let highlight: String
    
    var body: some View {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: highlight)
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        }
        return Text(AttributedString(attributedString)).foregroundColor(.gray) //전체 글씨는 회색. 하이라이트는 검정색
    }
}

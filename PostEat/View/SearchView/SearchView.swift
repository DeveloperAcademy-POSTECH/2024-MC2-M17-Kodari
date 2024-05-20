
import SwiftUI
import SwiftData

struct SearchView: View {
    var body: some View {
        BasicSearchView(searchMenu: .constant(""))
    }
}

struct BasicSearchView: View {
    
    @State private var searchText: String = ""
    @Binding var searchMenu: String
    @State var editText: Bool = false //검색창 지우기 할때 쓰는 변수
    
    @Query private var mealsdata: [FoodData] // 검색어 메뉴 목록 ( SwiftData에 저장되어있는 메뉴들 )
    
    // MARK: 검색 필터
    var searchResults: [FoodData] {
        if searchText.isEmpty {
            return mealsdata
        } else {
            return mealsdata.filter {
                $0.menu1.contains(searchText) ||
                $0.menu2.contains(searchText) ||
                $0.menu3.contains(searchText) ||
                $0.menu4.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Color.white
                .frame(height: 1)
            ZStack{
                Color("SystemGray")
                
                VStack{
                    TextField("메뉴를 검색하세요.", text: $searchText)
                        .padding(8)
                        .padding(.horizontal,10)
                        .background(Color(.systemGray6))
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
                                }
                                else {
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
                            ForEach(searchResults, id: \.id) { meal in
                                NavigationLink(destination: SearchResultsView(searchMenu: meal.menu1, mealsdata: mealsdata)) {
                                    HighlightedText(text: meal.menu1, highlight: searchText)
                                }

                                NavigationLink(destination: SearchResultsView(searchMenu: meal.menu2, mealsdata: mealsdata)) {
                                    HighlightedText(text: meal.menu2, highlight: searchText)
                                }

                                NavigationLink(destination: SearchResultsView(searchMenu: meal.menu3, mealsdata: mealsdata)) {
                                    HighlightedText(text: meal.menu3, highlight: searchText)
                                }

                                NavigationLink(destination: SearchResultsView(searchMenu: meal.menu4, mealsdata: mealsdata)) {
                                    HighlightedText(text: meal.menu4, highlight: searchText)
                                }
                            }
                        }
                        Spacer()
                    }
                    else {
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

#Preview{
    SearchView()
}

import SwiftUI

// MARK: 'SearchMenu'가 포함된 식단입니다. View
struct ResultsHeaderView: View {
    
    let searchMenu: String
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if searchMenu.count > 6 {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("\(searchMenu)")
                                .foregroundColor(Color(Constants.POSTECHRed))
                                .font(.system(size: 22))
                                .bold()
                            Text("\(josaDecision(searchMenu))")
                                .font(.system(size: 22))
                                .bold()
                        }
                        Text("포함된 식단")
                            .font(.system(size: 22))
                            .bold()
                    }
                    Spacer()
                } else {
                    Text("\(searchMenu)")
                        .foregroundColor(Color(Constants.POSTECHRed))
                        .font(.system(size: 22))
                        .bold()
                    Text("\(josaDecision(searchMenu)) 포함된 식단")
                        .font(.system(size: 22))
                        .bold()
                    Spacer()
                }
            }
            .background(.clear)
            .padding(.top)
            .padding(.leading)
        }
    }
    
    // MARK: 조사 알고리즘
    func josaDecision(_ name: String) -> String {
        // 글자 마지막 부분 가져오기
        guard let lastText = name.last else { return name }
        // 유니코드 변환
        let unicodeVal = UnicodeScalar(String(lastText))?.value
        
        guard let value = unicodeVal else { return name }
        // 한글아니면 반환
        if (value < 0xAC00 || value > 0xD7A3) { return name }
        // 종성인지 확인
        let last = (value - 0xAC00) % 28
        // 받침있으면 "이" 없으면 "가" 반환
        let str = last > 0 ? "이" : "가"
        return str
    } //조사결정
}

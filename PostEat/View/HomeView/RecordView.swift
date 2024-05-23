
import SwiftUI
import SwiftData

struct RecordView: View {
    
    //    @State var writeDate : String // 기록 날짜 변수
    @State var writeEatingNumber : String = "" // 기록 식사 인원 변수
    @State var writeMemo : String = "" // 기록 메모 변수
    
    @State var savePossible : Bool = false // 저장 버튼 활성화/비활성화
    @State var savedViewShowing : Bool = false // 저장 했을 때, 파란색 "저장됨" 뷰
    @Binding var recordModalShowing : Bool
    @Binding var selectedDate: Date
    //    @Binding var recordModalShowing : Bool
    
    @Bindable var mealData : FoodData
    
    private let calendar = Calendar.current //현재를 달력에 저장
    
    @State private var cancelNum : Int = 0
    @State private var cancelMemo : String = ""
    
    @State private var textfieldNum : Int = 0
    @State private var textfieldMemo : String = ""
    @State private var isFirstResponder = true
    
    var body: some View {
        ZStack{
            Color(red: 244 / 255, green: 244 / 255, blue: 244 / 255).ignoresSafeArea()
            VStack{
                HStack{
                    Button(action:{
                        recordModalShowing.toggle()
                        mealData.num = cancelNum
                        mealData.memo = cancelMemo
                    } ){
                        Text("취소")
                            .padding()
                    }
                    Spacer()
                    Button(action:{
                        savedViewShowing.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            //                            recordModalShowing.toggle()
                            mealData.num = textfieldNum
                            mealData.memo = textfieldMemo
                            savedViewShowing.toggle()
                            recordModalShowing.toggle()
                        }
                    } ){
                        Text("저장")
                            .padding()
                            .foregroundStyle(Color.blue)
                    }
                }
                
                Text("\(yearTitle(from: selectedDate))년 \(monthTitle(from: selectedDate))월 \(dayTitle(from: selectedDate))일 (\(day(from: selectedDate)))")
                    .font(.system(size:13))
                    .foregroundStyle(Color(Constants.POSTECHGray))
                
                
                if mealData.num == 0{
                    Text("\(mealData.uniqueid.last == "M" ? "조식" : mealData.uniqueid.last == "L" ? "중식" : "석식") 식수 기록하기")
                        .font(.system(size:22))
                        .foregroundStyle(Color.black)
                        .bold()
                } else{
                    Text("\(mealData.uniqueid.last == "M" ? "조식" : mealData.uniqueid.last == "L" ? "중식" : "석식") 식수 수정하기")
                        .font(.system(size:22))
                        .foregroundStyle(Color.black)
                        .bold()
                        .padding(.top)
                }
                VStack{
                    VStack{
                        HStack{
                            Text("식수")
                                .foregroundColor(.black)
                            
                            TextField("숫자 입력", text: Binding(
                                get: { String(textfieldNum) == "0" ? "" : String(textfieldNum) },
                                set: { textfieldNum = Int($0) ?? 0 } ))
                            .keyboardType(.decimalPad)  //키패드 종류(숫자)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                        }
                        .padding(.leading, 10)
                        
                        Divider()
                            .padding(5)
                        
                        HStack{
                            Text("메모")
                                .foregroundColor(.black)
                            TextField("교내 행사 등 특이사항 입력", text: $textfieldMemo)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 10)
                        }
                        .padding(.leading, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                }
                .padding()
                Spacer()
            }
            .padding(.top, 20)
            
            ZStack{
                Color(red: 27 / 255, green: 177 / 255, blue: 211 / 255)
                    .opacity(1)
                HStack{
                    Image(systemName:"checkmark.circle.fill")
                        .frame(width:31, height:31)
                        .foregroundStyle(Color.white)
                    Text("저장됨")
                        .font(.system(size:24))
                        .bold()
                        .foregroundStyle(Color.white)
                }
            }
            .opacity(savedViewShowing ? 1 : 0) // opacity 1로 설정
            .animation(.easeIn(duration: 0.5), value: savedViewShowing)
        }
        .onAppear(){
            cancelNum = mealData.num
            cancelMemo = mealData.memo
            textfieldNum = mealData.num
            textfieldMemo = mealData.memo
        }
    }
}

// MARK: - 로직
private extension RecordView {
    /// 년 추출
    func yearTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 월 추출
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("M")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 일 추출
    func dayTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: date)
    }
    
    /// 월 변경
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(
            byAdding: .month,
            value: value,
            to: selectedDate
        ) else {
            return
        }
        
        selectedDate = date
    }
    
    /// 요일 추출
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E") //영어로 요일 표시 (간략하게)
        dateFormatter.locale = Locale(identifier: "ko_kr") //한글로 요일 표시
        return dateFormatter.string(from: date)
    }
}

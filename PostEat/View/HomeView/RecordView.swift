
import SwiftUI
import SwiftData

struct RecordView: View {
    
    //    @State var writeDate : String // 기록 날짜 변수
    @State var writeEatingNumber : String = "" // 기록 식사 인원 변수
    @State var writeMemo : String = "" // 기록 메모 변수
    
    @State var savePossible : Bool = false // 저장 버튼 활성화/비활성화
    @State var savedViewShowing : Bool = false // 저장 했을 때, 파란색 "저장됨" 뷰
    @Binding var recordModalShowing : Bool
    //    @Binding var recordModalShowing : Bool
    
    @Bindable var mealData : FoodData
    
    
    var body: some View {
        ZStack{
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255).ignoresSafeArea()
            VStack{
                HStack{
                    Button(action:{
                        recordModalShowing.toggle()
                    } ){
                        Text("취소")
                            .padding()
                    }
                    Spacer()
                    Text("새로운 기록")
                    
                    Spacer()
                    Button(action:{
                        savedViewShowing.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            //                            recordModalShowing.toggle()
                            savedViewShowing.toggle()
                            recordModalShowing.toggle()
                        }
                    } ){
                        Text("저장")
                            .padding()
                            .foregroundStyle(Color.blue)
                    }
                }
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundStyle(Color.white)
                        .frame(width:361, height:132)
                    VStack{
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "2024년 5월 12일",
                            bindingText: $mealData.date,
                            recordName: "날짜")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "000",
                            bindingText: Binding(
                                get: { String(mealData.num) },
                                set: { mealData.num = Int($0) ?? 0 }
                            ),
                            recordName: "식사 인원")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "요구르트 모자람",
                            bindingText: $mealData.memo,
                            recordName: "메모")
                        Spacer()
                        
                    }
                    VStack{
                        Spacer()
                        Divider().padding(.horizontal, 13)
                        Spacer()
                        Divider().padding(.horizontal, 13)
                        Spacer()
                    }
                }.frame(width:361, height:132)
                Spacer()
            }.padding(.top, 20)
            
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
            }.opacity(savedViewShowing ? 1 : 0) // opacity 1로 설정
                .animation(.easeIn(duration: 0.5), value: savedViewShowing)
        }
    }
}

struct recordTextField : View{
    var recordPlaceholder : String
    @Binding var bindingText : String
    var recordName : String
    
    var body:some View{
        HStack{
            HStack{
                Text(recordName)
                Spacer()
            }.frame(width:100)
                .padding(.leading, 16)
            
            TextField("\(recordPlaceholder)", text: $bindingText)
        }
    }
}

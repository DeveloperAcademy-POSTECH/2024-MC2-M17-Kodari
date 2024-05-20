
import SwiftUI

struct RecordView: View {
    
    @State var writeDate : String = "" // 기록 날짜 변수
    @State var writeEatingNumber : String = "" // 기록 식사 인원 변수
    @State var writeMemo : String = "" // 기록 메모 변수
    
    @State var savePossible : Bool = false // 저장 버튼 활성화/비활성화
    @State var savedViewShowing : Bool = false // 저장 했을 때, 파란색 "저장됨" 뷰
    @State var recordModalShowing : Bool = true
    //    @Binding var recordModalShowing : Bool
    
    
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            //                            recordModalShowing.toggle()
                            savedViewShowing.toggle()
                        }
                    } ){
                        Text("저장")
                            .padding()
                            .foregroundStyle(writeEatingNumber.count >= 1 ? Color.blue : Color.gray)
                    }
                    .disabled(writeEatingNumber.count == 0) // 조건이 참일 때 버튼 비활성화
                    
                }
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundStyle(Color.white)
                        .frame(width:361, height:132)
                    VStack{
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "2024년 5월 12일",
                            bindingText: $writeDate,
                            recordName: "날짜")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "000",
                            bindingText: $writeEatingNumber,
                            recordName: "식사 인원")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "요구르트 모자람",
                            bindingText: $writeMemo,
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
            }
            
            ZStack{
                Color(red: 27 / 255, green: 177 / 255, blue: 211 / 255)
                    .opacity(0.7)
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

#Preview {
    RecordView()
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

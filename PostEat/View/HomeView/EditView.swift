
import SwiftUI

struct EditView: View {
    
    @State var editDate : String = ""
    @State var editEatingNumber : String = ""
    @State var editMemo : String = ""
    
    @State var editSavePossible : Bool = false
    @State var editModalShowing : Bool = true
//    @Binding var recordModalShowing : Bool
    
    var body: some View {
        ZStack{
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255).ignoresSafeArea()
            VStack{
                HStack{
                    Button(action:{
                        editModalShowing.toggle()
                        editDate = ""
                        editEatingNumber = ""
                        editMemo = ""
                    } ){
                        Text("취소")
                            .padding()
                    }
                    Spacer()
                    Text("기록 수정하기")
                    
                    Spacer()
                    Button(action:{
                        
                    } ){
                        Text("저장")
                            .padding()
                            .foregroundStyle(editEatingNumber.count >= 1 ? Color.blue : Color.gray)
                    }
                    .disabled(editEatingNumber.count == 0) // 조건이 참일 때 버튼 비활성화

                }
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundStyle(Color.white)
                        .frame(width:361, height:132)
                    VStack{
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "2024년 5월 12일",
                            bindingText: $editDate,
                            recordName: "날짜")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "000",
                            bindingText: $editEatingNumber,
                            recordName: "식사 인원")
                        Spacer()
                        recordTextField(
                            recordPlaceholder: "요구르트 모자람",
                            bindingText: $editMemo,
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
        }
    }
}

#Preview {
    EditView()
}

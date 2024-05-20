
import SwiftUI

struct CellView: View {
    let columns = [GridItem(.flexible())]
    let eatingTime: [Array] = [["조식", "07:30 ~ 09:30"], ["중식", "11:30 ~ 13:30"], ["석식", "17:30 ~ 19:00"]]
    
    var body: some View {
        ZStack{
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255).ignoresSafeArea()
            
            LazyVGrid(columns: columns) {
                ForEach(eatingTime, id: \.self) { eatingTime in
                    Button(action:{
                        
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 360, height: 163)
                                .foregroundStyle(Color.white)
                            
                            HStack{
                                VStack{
                                    HStack{
                                        Text("\(eatingTime[0])")
                                            .font(.system(size: 15))
                                            .bold()
                                            .foregroundStyle(Color.black)
                                            .frame(width:30)
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 9)
                                                .frame(width:86, height:20)
                                                .foregroundStyle(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                            Text("\(eatingTime[1])")
                                                .font(.system(size:11))
                                                .foregroundStyle(Color.black)
                                        }
                                        Spacer()
                                    }
                                    ForEach(["꽃게된장국", "돈육피망볶음", "도토리묵들기름무침", "치커리사과무침"], id: \.self) { menu in
                                        HStack{
                                            Text("\(menu)")
                                                .font(.system(size:15))
                                                .padding(0.5)
                                                .foregroundStyle(Color.black)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.leading, 22)
                                
                                VStack{
                                    HStack{
                                        Spacer()
                                        Image(systemName:"checkmark.circle.fill")
                                            .foregroundStyle(Color(red: 132 / 255, green: 197 / 255, blue: 243 / 255))
                                            .padding(.top, 15)
                                    }
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 9)
                                                .frame(width:61.4, height:20)
                                                .foregroundStyle(Color(red: 132 / 255, green: 197 / 255, blue: 243 / 255))
                                            Text("000명 방문")
                                                .font(.system(size:11))
                                                .bold()
                                                .foregroundStyle(Color.white)
                                        }
                                        .padding(.bottom, 15)
                                    }
                                }
                                .padding(.trailing, 22)
                                
                            }
                        }
                        .frame(width: 360, height: 163)
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    CellView()
}

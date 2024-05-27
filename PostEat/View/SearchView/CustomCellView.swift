
import SwiftUI

struct CustomCellView: View {
    
    let foodData: FoodData
    let searchMenu: String
    
    @State var isFlipped = false
    
    var body: some View {
        
        ZStack{
            if isFlipped {
                MemoView(memo: foodData.memo)
            } else {
                ResultCellView(uniqueid: foodData.uniqueid, noCount: foodData.num, tempdate: foodData.date, day: foodData.date)
            }
        }
        .scaleEffect(x: isFlipped ? -1 : 1)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: -1, z: 0))
        .onTapGesture {
            isFlipped.toggle()
        }
        
    }
    
    func ResultCellView(uniqueid: String ,noCount: Int, tempdate: String, day: String) -> some View{
        HStack {
            VStack {
                mealTypeBadge(mealType: foodData.uniqueid, noCount: foodData.num)
                counterBadge(count: foodData.num, tempdate: foodData.date)
                dateBadge(day: foodData.date, noCount: foodData.num)
            }
            
            HStack{
                Divider()
                    .frame(maxHeight: .infinity)
                    .background(Constants.AppleGray)
            }
            .padding(.vertical, 10)
            
            VStack {
                mealContents(menu1: foodData.menu1, menu2: foodData.menu2, menu3: foodData.menu3, menu4: foodData.menu4)
            }
            .padding(10)
            Spacer()
            
            VStack{
                noteAndWeatherIcon(useMemo: foodData.memo)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(25)
    }
    
    func MemoView(memo: String) -> some View{
        VStack {
            VStack {
                HStack{
                    Text("메모")
                        .font(.system(size: 15))
                        .foregroundColor(Constants.POSTECHGray)
                        .fontWeight(.heavy)
                        .padding(5)
                    Spacer()
                }
                HStack {
                    Text (memo)
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(Constants.POSTECHGray)
                        .padding(5)
                    
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .resizable()
                        .frame(width:24, height: 24)
                        .foregroundColor(Color.gray.opacity(0.3))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 137)
        .background(.white)
        .cornerRadius(25)
    }
    
    func parseDateString(_ dateString: String) -> (datePart: String, dayOfWeek: String) {
        let components = dateString.split(separator: ":")
        if components.count == 3 {
            let year = String(components[0])
            let month = String(components[1])
            let day = String(components[2])
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"
            guard let date = dateFormatter.date(from: dateString) else {
                return (dateString, "")
            }
            
            dateFormatter.dateFormat = "MM월 dd일"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            let datePart = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateFormatter.string(from: date)
            
            return (datePart, dayOfWeek)
        } else {
            return (dateString, "")
        }
    }
    
    func counterBadge(count: Int, tempdate: String) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: tempdate) ?? Date()
        let isFutureDate = Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
        
        var displayText: String
        if count == 0 {
            if isFutureDate {
                displayText = "배식전"
            } else {
                displayText = "미입력"
            }
        } else {
            displayText = "\(count)명"
        }
        
        return ZStack {
            Rectangle()
                .frame(width: 80, height: 22)
                .foregroundColor(.clear)
            
            Text(displayText)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 26)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(displayText == "미입력" ? Constants.KODARIGray : Constants.KODARIBlue)
                .frame(width: 80, height: 22, alignment: .center)
        }
    }
    
    func dateBadge(day: String, noCount: Int) -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 70, height: 30)
            
            Text("\(parseDateString(day).datePart) \n \(parseDateString(day).dayOfWeek)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 12)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(noCount == 0 ? Constants.KODARIGray : Constants.POSTECHGray)
                .frame(alignment: .center)
        }
    }
    
    func mealContents(menu1: String, menu2: String, menu3: String, menu4: String)-> some View{
        
        return VStack(alignment: .leading, spacing: 0.5){
            
            Text(menu1)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu1.contains(searchMenu) ? .bold : .regular)
                )
                .foregroundColor(menu1.contains(searchMenu) ? Constants.POSTECHRed : Color.black)
                .padding(2)
            
            Text(menu2)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu2.contains(searchMenu) ? .bold : .regular)
                )
                .foregroundColor(menu2.contains(searchMenu) ? Constants.POSTECHRed : Color.black)
                .padding(2)
            
            Text(menu3)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu3.contains(searchMenu) ? .bold : .regular)
                )
                .foregroundColor(menu3.contains(searchMenu) ? Constants.POSTECHRed : Color.black)
                .padding(2)
            
            Text(menu4)
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(menu4.contains(searchMenu) ? .bold : .regular)
                )
                .foregroundColor(menu4.contains(searchMenu) ? Constants.POSTECHRed : Color.black)
                .padding(2)
        }
        
    }
    
    func mealTypeBadge(mealType: String, noCount: Int)-> some View{
        let mealTypeText: String
        switch mealType.last {
        case "M":
            mealTypeText = "조식"
        case "L":
            mealTypeText = "중식"
        case "D":
            mealTypeText = "석식"
        default:
            mealTypeText = "알 수 없음"
        }
        
        return ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 37, height: 22)
                .background(noCount == 0 ? Constants.KODARIGray : Constants.KODARIBlue)
                .cornerRadius(7)
            
            Text("\(mealTypeText)")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 14)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 29.80556, height: 13, alignment: .center)
        }
    }
    
    func noteAndWeatherIcon(useMemo: String) -> some View {
        HStack {
            Image(systemName: "list.bullet.circle.fill")
                .resizable()
                .foregroundColor(useMemo.count > 0 ? Constants.KODARIBlue : Constants.KODARIGray.opacity(0.15))
                .frame(width: 24, height: 24)
                .contentShape(Circle())
        }
    }
}

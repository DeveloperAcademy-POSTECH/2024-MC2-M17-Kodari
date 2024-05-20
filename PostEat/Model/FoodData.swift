import Foundation
import SwiftData

@Model
class FoodData: Identifiable {
    
    @Attribute(.unique) var id = UUID()
    
    var uniqueid: String
    var date: String
    var menu1: String
    var menu2: String
    var menu3: String
    var menu4: String
    var num: String// Ing 형 .?
    //var memo: String
    
    init(uniqueid: String, date: String, menu1: String, menu2: String, menu3: String, menu4: String, num: String ) {
        self.uniqueid = uniqueid
        self.date = date
        self.menu1 = menu1
        self.menu2 = menu2
        self.menu3 = menu3
        self.menu4 = menu4
        self.num = num
      //  self.memo = memo
    }
}

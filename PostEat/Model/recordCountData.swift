import Foundation
import SwiftData

@Model
class recordCountData: Identifiable {
    
    @Attribute(.unique) var id = UUID()
    
    var date: Date
    var recordCount: Int
    
    init(date:Date, recordCount: Int) {
        self.date = date
        self.recordCount = recordCount
    }
}

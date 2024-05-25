import SwiftUI
import SwiftData

@main
struct PostEatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var modelContainer: ModelContainer
        
        init() {
            Thread.sleep(forTimeInterval: 2)
            do {
                modelContainer = try ModelContainer(for: FoodData.self, recordCountData.self)
            } catch {
                fatalError("Failed to configure SwiftData container.")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            DateView()
                .modelContainer(modelContainer)
        }
    }
}

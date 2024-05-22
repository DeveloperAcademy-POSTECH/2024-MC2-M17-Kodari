import SwiftUI
import SwiftData

@main
struct PostEatApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([FoodData.self])
          let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
          
          do {
              return try ModelContainer(for: schema, configurations: [modelConfiguration])
          } catch {
              fatalError("Could not create ModelContainer: \(error)")
          }
      }()
    
    @State var selectedDate : Date = Date()
    
    var body: some Scene {
        WindowGroup {
            DateView(selectedDate:$selectedDate)
                .modelContainer(modelContainer)
        }
    }
}

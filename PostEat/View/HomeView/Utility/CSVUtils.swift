import Foundation
import SwiftData

struct CSVUtils {
    static func saveCSVData(mealdata: inout [FoodData], modelContext: ModelContext) {
        guard let url = Bundle.main.url(forResource: "MealData", withExtension: "csv") else {
            print("CSV file not found")
            return
        }

        do {
            let data = try String(contentsOf: url)
            let rows = data.components(separatedBy: "\n").dropFirst()
            mealdata = rows.compactMap { row -> FoodData? in
                let components = row.components(separatedBy: ",")
                guard components.count >= 7 else { return nil }

                let trimmedNum = components[6].trimmingCharacters(in: .whitespacesAndNewlines)
                let convertnum = Int(trimmedNum) ?? 0

                let newData = FoodData(uniqueid: components[0], date: components[1], menu1: components[2], menu2: components[3], menu3: components[4], menu4: components[5], num: convertnum, memo:"")
                modelContext.insert(newData)
                return newData
            }
        } catch {
            print("Error reading CSV file:", error.localizedDescription)
        }
    }

    static func saveRecordCountCSVData(recorddata: inout [recordCountData], modelContext: ModelContext) {
        guard let url = Bundle.main.url(forResource: "recordCount", withExtension: "csv") else {
            print("CSV file not found")
            return
        }

        do {
            let data = try String(contentsOf: url)
            let rows = data.components(separatedBy: "\n").dropFirst()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"

            recorddata = rows.compactMap { row -> recordCountData? in
                let components = row.components(separatedBy: ",")
                guard components.count >= 2 else { return nil }

                let date = dateFormatter.date(from: components[0]) ?? Date()
                let trimmedNum = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let recordCount = Int(trimmedNum) ?? 0

                let newData = recordCountData(date: date, recordCount: recordCount)
                modelContext.insert(newData)
                return newData
            }
        } catch {
            print("Error reading CSV file:", error.localizedDescription)
        }
    }
}

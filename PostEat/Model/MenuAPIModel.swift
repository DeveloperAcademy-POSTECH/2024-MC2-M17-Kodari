import SwiftUI
import Combine
import SwiftData

// 모델 정의
struct Food: Codable {
    let id: Int
    let name_kor: String
    let name_eng: String
    let isVegan: Bool
    let isMain: Bool
}

struct Meal: Codable {
    let id: Int
    let date: Int
    let type: String
    let foods: [Food]
    let kcal: Int
    let protein: Int
}

class MenuAPIModel: ObservableObject {
    var foodDatas : [FoodData]?

    @Published var breakfastMenus: [String] = []
    @Published var lunchMenus: [String] = []
    @Published var dinnerMenus: [String] = []
    @Published var jsonString: String = ""

    func getMenus(foodDatas:[FoodData], modelContext:ModelContext) {
        
        // DateFormatter 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd"
        
        func findLatestMeal(from data: [FoodData]) -> FoodData? {
            return data.max(by: {
                guard let date1 = dateFormatter.date(from: $0.date),
                      let date2 = dateFormatter.date(from: $1.date) else {
                    return false
                }
                return date1 < date2
            })
        }
        
        let calendar = Calendar.current
        let latestMeal = findLatestMeal(from: foodDatas)
        var requireDay = dateFormatter.date(from: latestMeal!.date)!
        // 첫번째 날을 requireDay로 설정하고 다음 날로 설정
        requireDay = calendar.date(byAdding: .day, value: 1, to: requireDay)!
        
        func fetchMenus(for date: Date, requestCount: Int) {
            guard requestCount <= 20 else {
//                print("Reached maximum request count of 14.")
                return
            }
            
            let year = String(calendar.component(.year, from: date))
            let month = String(format: "%02d", calendar.component(.month, from: date))
            let day = String(format: "%02d", calendar.component(.day, from: date))
            
            guard let url = URL(string: "https://food.podac.poapper.com/v1/menus/\(year)/\(month)/\(day)") else {
                fatalError("Missing URL")
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      let contentLengthString = response.allHeaderFields["Content-Length"] as? String,
                      let contentLength = Int(contentLengthString) else {
                    return
                }
                
                if contentLength >= 50 {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let meals = try decoder.decode([Meal].self, from: data)
                            
                            DispatchQueue.main.async {
                                
                                self.breakfastMenus = meals.filter { $0.type == "BREAKFAST_A"/* || $0.type == "BREAKFAST_B" */}.flatMap { $0.foods.map { $0.name_kor } }
                                modelContext.insert(FoodData(uniqueid: "\(dateFormatter.string(from: date))_M",
                                                                  date: dateFormatter.string(from:date),
                                                                  menu1: self.breakfastMenus.indices.contains(0) ? self.breakfastMenus[0] : "-",
                                                                  menu2: self.breakfastMenus.indices.contains(1) ? self.breakfastMenus[1] : "-",
                                                                  menu3: self.breakfastMenus.indices.contains(2) ? self.breakfastMenus[2] : "-",
                                                                  menu4: self.breakfastMenus.indices.contains(3) ? self.breakfastMenus[3] : "-",
                                                             num: 0,
                                                             memo: self.breakfastMenus.indices.contains(4) ? self.breakfastMenus[4] : ""
                                                            ))
                                self.lunchMenus = meals.filter { $0.type == "LUNCH" }.flatMap { $0.foods.map { $0.name_kor } }
                                modelContext.insert(FoodData(uniqueid: "\(dateFormatter.string(from: date))_M",
                                                                  date: dateFormatter.string(from:date),
                                                                  menu1: self.lunchMenus.indices.contains(0) ? self.lunchMenus[0] : "-",
                                                                  menu2: self.lunchMenus.indices.contains(1) ? self.lunchMenus[1] : "-",
                                                                  menu3: self.lunchMenus.indices.contains(2) ? self.lunchMenus[2] : "-",
                                                                  menu4: self.lunchMenus.indices.contains(3) ? self.lunchMenus[3] : "-",
                                                             num: 0,
                                                             memo: self.lunchMenus.indices.contains(4) ? self.lunchMenus[4] : ""
                                                            ))
                                self.dinnerMenus = meals.filter { $0.type == "DINNER" }.flatMap { $0.foods.map { $0.name_kor } }
                                modelContext.insert(FoodData(uniqueid: "\(dateFormatter.string(from: date))_M",
                                                                  date: dateFormatter.string(from:date),
                                                                  menu1: self.dinnerMenus.indices.contains(0) ? self.dinnerMenus[0] : "-",
                                                                  menu2: self.dinnerMenus.indices.contains(1) ? self.dinnerMenus[1] : "-",
                                                                  menu3: self.dinnerMenus.indices.contains(2) ? self.dinnerMenus[2] : "-",
                                                                  menu4: self.dinnerMenus.indices.contains(3) ? self.dinnerMenus[3] : "-",
                                                             num: 0,
                                                             memo: self.dinnerMenus.indices.contains(4) ? self.dinnerMenus[4] : ""
                                                            ))
                            }
                        } catch {
                            print("Decoding error: ", error)
                        }
                    }
                    // 날짜를 하루 더하고 다음 요청을 위해 요청 횟수를 증가시킴
                    let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
                    fetchMenus(for: nextDay, requestCount: requestCount + 1)
                } else {
                    // Content-Length가 50 이하인 경우 요청 중단
//                    print("Content-Length is 50 or less, stopping requests.")
                }
            }
            dataTask.resume()
        }
        fetchMenus(for: requireDay, requestCount: 1)
    }
}

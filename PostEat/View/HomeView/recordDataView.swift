//
//  recordDataView.swift
//  PostEat
//
//  Created by 변준섭 on 5/23/24.
//

import SwiftUI
import SwiftData

struct recordDataView: View {
    
    @Query var recordCountDatas: [recordCountData]
    @Query var mealdatas: [FoodData]
    var body: some View {
        ScrollView{
            ForEach(recordCountDatas) { i in
                Text("\(i.date)")
                Text("\(i.recordCount)")
            }
        }
        
    }
}

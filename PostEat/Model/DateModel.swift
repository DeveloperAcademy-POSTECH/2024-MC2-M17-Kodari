//
//  DateValue.swift
//  ElegantTaskApp
//
//  Created by 변준섭 on 5/19/24.
//

import SwiftUI

//DateValue Model...
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

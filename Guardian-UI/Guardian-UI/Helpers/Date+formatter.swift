//
//  Date+foramtter.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
public extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}

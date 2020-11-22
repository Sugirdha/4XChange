//
//  XChangeModel.swift
//  4XChange
//
//  Created by Sugirdha on 19/11/20.
//

import Foundation

struct XChangeModel: Codable {
    let baseCurrency: String
    let rate: Double
    var currencyArray: [String]
}

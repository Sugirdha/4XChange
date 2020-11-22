//
//  XChangeRateData.swift
//  4XChange
//
//  Created by Sugirdha on 19/11/20.
//

import Foundation

struct XChangeRateData: Codable {
    let result: String
    let base_code: String
    let conversion_rates: [String: Double]
}

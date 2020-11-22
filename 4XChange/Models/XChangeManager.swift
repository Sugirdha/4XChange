//
//  XChangeManager.swift
//  4XChange
//
//  Created by Sugirdha on 19/11/20.
//

import Foundation
import UIKit

protocol XChangeManagerDelegate {
    func didUpdateCurrencyPickers(_ xChangeManager: XChangeManager, exchangedModel: XChangeModel)
    func didUpdateXChangeRate(_ xChangeManager: XChangeManager, exchangedModel: XChangeModel)
    func didFailWithError(error: Error)
}

struct XChangeManager {
    
    let baseUrl = "https://v6.exchangerate-api.com/v6/\(Keys.apiKey)/latest/"
    var delegate: XChangeManagerDelegate?
    
    func getCurrencyArray(_ currency1: String, to currency2: String) {
        let urlString = "\(baseUrl)\(currency1)"
        performRequest(with: urlString, and: currency2) { (exchangedModel) in
            self.delegate?.didUpdateCurrencyPickers(self, exchangedModel: exchangedModel)
        }
    }

    func getXchangeRate(_ currency1: String, to currency2: String) {
        let urlString = "\(baseUrl)\(currency1)"
        performRequest(with: urlString, and: currency2) { (exchangedModel) in
            self.delegate?.didUpdateXChangeRate(self, exchangedModel: exchangedModel)
        }
    }

    func performRequest(with urlString: String, and currency2 : String, completion: @escaping (XChangeModel) -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
                    
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let exchangedModel = parseJSON(safeData, currency2) {
                        completion(exchangedModel)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data, _ toCurrency: String) -> XChangeModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(XChangeRateData.self, from: data)
            let baseCurrency = decodedData.base_code
            let rate = decodedData.conversion_rates[toCurrency]
            
            var currencyArray: [String] = []
            for countryCode in decodedData.conversion_rates {
                currencyArray.append(countryCode.key)
            }
            currencyArray.sort()
            
            let exchangedModel = XChangeModel(baseCurrency: baseCurrency, rate: rate!, currencyArray: currencyArray)
            
            return exchangedModel
        } catch {
            print("error found while decoding data")
            return nil
        }
    }
    
}

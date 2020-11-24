//
//  ViewController.swift
//  4XChange
//
//  Created by Sugirdha on 19/11/20.
//

import UIKit
import iOSDropDown

class CurrencyXChangeViewController: UIViewController {

    @IBOutlet weak var baseCurrencyDropDown: DropDown!
    @IBOutlet weak var targetCurrencyDropDown: DropDown!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var invertButton: UIButton!
    
    var xChangeManager = XChangeManager()
    var currencies: [String] = []
    var rate: Double = 0.00
    
    //Use UserDefaults after adding a few more updates
    let defaultCurrency = "SGD"
    let favouriteCurrency = "USD"
    
    var baseCurrency = String()
    var targetCurrency = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let invertImage = UIImage(systemName: "arrow.up.arrow.down")
        invertButton.setImage(invertImage, for: .normal)
        
        xChangeManager.delegate = self
        
        baseCurrency = defaultCurrency
        targetCurrency = favouriteCurrency
        
        xChangeManager.getCurrencyArray(baseCurrency, to: targetCurrency)
        xChangeManager.getXchangeRate(baseCurrency, to: targetCurrency)
        
        
        baseCurrencyDropDown.didSelect { (selectedBaseCurrency, index, id) in
            self.baseCurrency = selectedBaseCurrency
            self.xChangeManager.getXchangeRate(self.baseCurrency, to: self.targetCurrency)
        }
        
        targetCurrencyDropDown.didSelect { (selectedTargetCurrency, index, id) in
            self.targetCurrency = selectedTargetCurrency
            self.xChangeManager.getXchangeRate(self.baseCurrency, to: self.targetCurrency)
        }
    }
    
    
    @IBAction func invertButtonPressed(_ sender: UIButton) {
        swap(&baseCurrency, &targetCurrency)
        DispatchQueue.main.async {
            self.xChangeManager.getXchangeRate(self.baseCurrency, to: self.targetCurrency)
            self.baseCurrencyDropDown.text = self.baseCurrency
            self.targetCurrencyDropDown.text = self.targetCurrency
        }
    }
    
}

//MARK: - XchangeManagerDelegate

extension CurrencyXChangeViewController: XChangeManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }

    func didUpdateCurrencyPickers(_ xChangeManager: XChangeManager, exchangedModel: XChangeModel) {
        DispatchQueue.main.async {
            
            self.currencies = exchangedModel.currencyArray
            
            self.baseCurrencyDropDown.optionArray = self.currencies
            self.targetCurrencyDropDown.optionArray = self.currencies
            
            if let baseCurrIndex = self.currencies.firstIndex(of: self.defaultCurrency) {
                self.baseCurrency = self.currencies[baseCurrIndex]
                self.baseCurrencyDropDown.text = self.baseCurrency
            }
            
            if let targetCurrIndex = self.currencies.firstIndex(of: self.favouriteCurrency) {
                self.targetCurrency = self.currencies[targetCurrIndex]
                self.targetCurrencyDropDown.text = self.targetCurrency
            }
        }
    }
    
    func didUpdateXChangeRate(_ xChangeManager: XChangeManager, exchangedModel: XChangeModel) {
        DispatchQueue.main.async {
            let rateString = String(format: "%.5f", exchangedModel.rate)
            self.exchangeRateLabel.text = "1 \(self.baseCurrency) = \(rateString) \(self.targetCurrency)"
        }
    }
    
}


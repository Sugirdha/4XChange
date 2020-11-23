//
//  ViewController.swift
//  4XChange
//
//  Created by Sugirdha on 19/11/20.
//

import UIKit

class CurrencyXChangeViewController: UIViewController {

    @IBOutlet weak var baseCurrencyPicker: UIPickerView!
    @IBOutlet weak var targetCurrencyPicker: UIPickerView!
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
        baseCurrencyPicker.delegate = self
        baseCurrencyPicker.dataSource = self
        targetCurrencyPicker.delegate = self
        targetCurrencyPicker.dataSource = self

        xChangeManager.getCurrencyArray(defaultCurrency, to: favouriteCurrency)
        xChangeManager.getXchangeRate(defaultCurrency, to: favouriteCurrency)
    }

    func updatePickerUI(paramBaseCurr: String, paramTargetCurr: String) {
        
        if let row = self.currencies.firstIndex(of: paramBaseCurr) {
            self.baseCurrencyPicker.selectRow(row, inComponent: 0, animated: true)
            self.pickerView(self.baseCurrencyPicker, didSelectRow: row, inComponent: 0)
        }
    
        if let row = self.currencies.firstIndex(of: paramTargetCurr) {
            self.targetCurrencyPicker.selectRow(row, inComponent: 0, animated: true)
            self.pickerView(self.targetCurrencyPicker, didSelectRow: row, inComponent: 0)
        }
    }
    
    @IBAction func invertButtonPressed(_ sender: UIButton) {
        swap(&baseCurrency, &targetCurrency)
        updatePickerUI(paramBaseCurr: baseCurrency, paramTargetCurr: targetCurrency)
        DispatchQueue.main.async {
            self.xChangeManager.getXchangeRate(self.baseCurrency, to: self.targetCurrency)
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
            self.baseCurrencyPicker.reloadAllComponents()
            self.targetCurrencyPicker.reloadAllComponents()
            
            self.updatePickerUI(paramBaseCurr: self.defaultCurrency, paramTargetCurr: self.favouriteCurrency)
        }
    }
    
    func didUpdateXChangeRate(_ xChangeManager: XChangeManager, exchangedModel: XChangeModel) {
        DispatchQueue.main.async {
            let rateString = String(format: "%.5f", exchangedModel.rate)
            self.exchangeRateLabel.text = "1 \(self.baseCurrency) = \(rateString) \(self.targetCurrency)"
        }
    }
    
}

//MARK: - PickerView - DataSource and Delegate

extension CurrencyXChangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        baseCurrency = currencies[baseCurrencyPicker.selectedRow(inComponent: 0)]
        targetCurrency = currencies[targetCurrencyPicker.selectedRow(inComponent: 0)]
        xChangeManager.getXchangeRate(baseCurrency, to: targetCurrency)
    }

}

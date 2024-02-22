//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import Foundation

extension ContentView {
    @Observable
    class ViewModel {
        var sourceAmount = ""
        var selectedSourceCurrency = Currency.usd
        var selectedTargetCurrency = Currency.rub
        var currencyRates: [String: Double] = [:]
        var conversionHistory: [ConversionEntry] = []
        
        var convertedAmount: Double {
            guard let sourceRate = currencyRates[selectedSourceCurrency.rawValue],
                  let targetRate = currencyRates[selectedTargetCurrency.rawValue],
                  let amount = Double(sourceAmount) else {
                return 0.0
            }
            
            return (amount / sourceRate) * targetRate
        }
        
        func addToHistory() {
            let entry = ConversionEntry(sourceCurrency: selectedSourceCurrency, targetCurrency: selectedTargetCurrency, sourceAmount: Double(sourceAmount) ?? 0, convertedAmount: convertedAmount, timestamp: Date())
            
            conversionHistory.insert(entry, at: 0)
        }
        
        func fetchRates() {
            CurrencyService.shared.fetchCurrencyRates { result in
                switch result {
                case .success(let rates):
                    DispatchQueue.main.async {
                        self.currencyRates = rates
                        self.saveCurrencyRatesLocally()
                    }
                case .failure(let error):
                    print("Failed to fetch currency rates: \(error)")
                }
            }
        }
        
        func saveCurrencyRatesLocally() {
            UserDefaults.standard.set(currencyRates, forKey: "currencyRates")
        }
        
        func loadSelectedCurrencyPair() {
            if let sourceCurrencyRawValue = UserDefaults.standard.string(forKey: "sourceCurrency"),
               let sourceCurrency = Currency(rawValue: sourceCurrencyRawValue),
               let targetCurrencyRawValue = UserDefaults.standard.string(forKey: "targetCurrency"),
               let targetCurrency = Currency(rawValue: targetCurrencyRawValue) {
                selectedSourceCurrency = sourceCurrency
                selectedTargetCurrency = targetCurrency
            }
        }
        
        func saveSelectedCurrencyPairLocally() {
            UserDefaults.standard.set(selectedSourceCurrency.rawValue, forKey: "sourceCurrency")
            UserDefaults.standard.set(selectedTargetCurrency.rawValue, forKey: "targetCurrency")
        }
    }
}

//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import Foundation
import SwiftUI

@Observable
class ViewModel {
    var sourceAmount = ""
    var selectedSourceCurrency = Currency.usd
    var selectedTargetCurrency = Currency.rub
    var currencyRates: [String: Double] = [:]
    var conversionHistory: [ConversionEntry] = []
    var timer: Timer?
    
    let currencies: [Currency] = [.rub, .usd, .eur, .gbp, .chf, .cny]
    
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
        UserDefaults.standard.set(Date(), forKey: "cachedRatesTimestamp")
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
    
    func startRefreshTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 21600, repeats: true) { _ in
            self.fetchRates()
        }
    }
    
    func loadCachedCurrencyRates() {
        if let cachedRates = UserDefaults.standard.dictionary(forKey: "currencyRates") as? [String: Double] {
            currencyRates = cachedRates
        } else {
            fetchRates()
        }
    }
    
    func saveConversionHistoryLocally() {
        let encoder = JSONEncoder()
        if let encodedHistory = try? encoder.encode(conversionHistory) {
            UserDefaults.standard.set(encodedHistory, forKey: "conversionHistory")
        }
    }
    
    func loadConversionHistory() {
        if let savedHistoryData = UserDefaults.standard.data(forKey: "conversionHistory") {
            let decoder = JSONDecoder()
            if let loadedHistory = try? decoder.decode([ConversionEntry].self, from: savedHistoryData) {
                conversionHistory = loadedHistory
            }
        }
    }
}

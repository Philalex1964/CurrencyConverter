//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

enum Currency: String, CaseIterable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case chf = "CHF"
    case cny = "CNY"
}

struct ContentView: View {
    @State private var sourceAmount = ""
    @State private var selectedSourceCurrency = Currency.usd
    @State private var selectedTargetCurrency = Currency.rub
    @State private var currencyRates: [String: Double] = [:]
    @State private var conversionHistory: [ConversionEntry] = []
    @FocusState private var fieldIsFocused: Bool
    
    private let currencies: [Currency] = [.rub, .usd, .eur, .gbp, .chf, .cny]
    
    var convertedAmount: Double {
        guard let sourceRate = currencyRates[selectedSourceCurrency.rawValue],
              let targetRate = currencyRates[selectedTargetCurrency.rawValue],
              let amount = Double(sourceAmount) else {
            return 0.0
        }
        
        return (amount / sourceRate) * targetRate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Source")) {
                    Picker("Source Currency", selection: $selectedSourceCurrency) {
                        ForEach(currencies, id:\.self) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    TextField("Amount", text: $sourceAmount).focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Target")) {
                    Picker("Target Currency", selection: $selectedTargetCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Text("Converted Amount: \(convertedAmount, specifier: "%.2f") \(selectedTargetCurrency.rawValue)")
                }
                
                Button("Add to History", action: addToHistory)
            }
        }
    }
    
    func addToHistory() {
        let entry = ConversionEntry(sourceCurrency: selectedSourceCurrency, targetCurrency: selectedTargetCurrency, sourceAmount: Double(sourceAmount) ?? 0, convertedAmount: convertedAmount, timestamp: Date())
        
        conversionHistory.insert(entry, at: 0)
    }
}

#Preview {
    ContentView()
}

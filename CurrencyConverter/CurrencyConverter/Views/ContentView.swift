//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

struct ContentView: View {
    @State private var sourceAmount = ""
    @State private var selectedSourceCurrency = Currency.usd
    @State private var selectedTargetCurrency = Currency.rub
    @State private var currencyRates: [String: Double] = [:]
    @State private var conversionHistory: [ConversionEntry] = []
//    @State private var viewModel = ViewModel()
    
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
            .navigationBarTitle("Currency Converter")
            .onAppear {
                fetchRates()
                loadSelectedCurrencyPair()
            }
            .navigationBarItems(trailing:
                                    NavigationLink(destination: ConversionHistoryView(conversionHistory: $conversionHistory)) {
                Text("History")
            })
        }
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
                    saveCurrencyRatesLocally()
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

#Preview {
    ContentView()
}

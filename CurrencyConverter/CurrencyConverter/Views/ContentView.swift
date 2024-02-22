//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    @FocusState private var fieldIsFocused: Bool
    
    var convertedAmount: Double {
        guard let sourceRate = viewModel.currencyRates[viewModel.selectedSourceCurrency.rawValue],
              let targetRate = viewModel.currencyRates[viewModel.selectedTargetCurrency.rawValue],
              let amount = Double(viewModel.sourceAmount) else {
            return 0.0
        }
        
        return (amount / sourceRate) * targetRate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Source")) {
                    Picker("Source Currency", selection: $viewModel.selectedSourceCurrency) {
                        ForEach(viewModel.currencies, id:\.self) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    TextField("Amount", text: $viewModel.sourceAmount).focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Target")) {
                    Picker("Target Currency", selection: $viewModel.selectedTargetCurrency) {
                        ForEach(viewModel.currencies, id: \.self) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Text("Converted Amount: \(convertedAmount, specifier: "%.2f") \(viewModel.selectedTargetCurrency.rawValue)")
                }
                
                Button("Add to History", action: addToHistory)
            }
            .navigationBarTitle("Currency Converter")
            .onAppear {
                viewModel.loadCachedCurrencyRates()
                viewModel.loadConversionHistory()
                viewModel.loadSelectedCurrencyPair()
                viewModel.startRefreshTimer()
            }
            .onChange(of: viewModel.selectedTargetCurrency) { _, _ in
                viewModel.saveSelectedCurrencyPairLocally()
            }
            .onChange(of: viewModel.selectedTargetCurrency) { _, _ in
                viewModel.saveSelectedCurrencyPairLocally()
            }
            .onChange(of: viewModel.conversionHistory) { _, _ in
                viewModel.saveConversionHistoryLocally()
            }
            .navigationBarItems(trailing:
                                    NavigationLink(destination: ConversionHistoryView(conversionHistory: $viewModel.conversionHistory)) {
                Text("History")
            })
        }
    }
    
    func addToHistory() {
        let entry = ConversionEntry(sourceCurrency: viewModel.selectedSourceCurrency, targetCurrency: viewModel.selectedTargetCurrency, sourceAmount: Double(viewModel.sourceAmount) ?? 0, convertedAmount: convertedAmount, timestamp: Date())
        
        viewModel.conversionHistory.insert(entry, at: 0)
        fieldIsFocused = false
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

struct ContentView: View {
//    @State private var sourceAmount = ""
//    @State private var selectedSourceCurrency = Currency.usd
//    @State private var selectedTargetCurrency = Currency.rub
//    @State private var currencyRates: [String: Double] = [:]
//    @State private var conversionHistory: [ConversionEntry] = []
//    @State private var timer: Timer? 
    
    @State private var viewModel = ViewModel()
    
    @FocusState private var fieldIsFocused: Bool
    
    //private let currencies: [Currency] = [.rub, .usd, .eur, .gbp, .chf, .cny]
    
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
    
//    func fetchRates() {
//        CurrencyService.shared.fetchCurrencyRates { result in
//            switch result {
//            case .success(let rates):
//                DispatchQueue.main.async {
//                    viewModel.currencyRates = rates
//                    saveCurrencyRatesLocally()
//                }
//            case .failure(let error):
//                print("Failed to fetch currency rates: \(error)")
//            }
//        }
//    }
    
//    func saveCurrencyRatesLocally() {
//        UserDefaults.standard.set(viewModel.currencyRates, forKey: "currencyRates")
//        UserDefaults.standard.set(Date(), forKey: "cachedRatesTimestamp")
//    }
    
//    func loadSelectedCurrencyPair() {
//        if let sourceCurrencyRawValue = UserDefaults.standard.string(forKey: "sourceCurrency"),
//           let sourceCurrency = Currency(rawValue: sourceCurrencyRawValue),
//           let targetCurrencyRawValue = UserDefaults.standard.string(forKey: "targetCurrency"),
//           let targetCurrency = Currency(rawValue: targetCurrencyRawValue) {
//            viewModel.selectedSourceCurrency = sourceCurrency
//            viewModel.selectedTargetCurrency = targetCurrency
//        }
//    }
    
//    func saveSelectedCurrencyPairLocally() {
//        UserDefaults.standard.set(viewModel.selectedSourceCurrency.rawValue, forKey: "sourceCurrency")
//        UserDefaults.standard.set(viewModel.selectedTargetCurrency.rawValue, forKey: "targetCurrency")
//    }
    
//MARK: - PRIVATE
    
//    private func startRefreshTimer() {
//        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 21600, repeats: true) { _ in
//            viewModel.fetchRates()
//        }
//    }
    
//    private func stopRefreshTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
    
//    private func loadCachedCurrencyRates() {
//        if let cachedRates = UserDefaults.standard.dictionary(forKey: "currencyRates") as? [String: Double] {
//            viewModel.currencyRates = cachedRates
//        } else {
//            viewModel.fetchRates()
//        }
//    }
    
//    private func saveConversionHistoryLocally() {
//        let encoder = JSONEncoder()
//        if let encodedHistory = try? encoder.encode(viewModel.conversionHistory) {
//            UserDefaults.standard.set(encodedHistory, forKey: "conversionHistory")
//        }
//    }
    
//    private func loadConversionHistory() {
//        if let savedHistoryData = UserDefaults.standard.data(forKey: "conversionHistory") {
//            let decoder = JSONDecoder()
//            if let loadedHistory = try? decoder.decode([ConversionEntry].self, from: savedHistoryData) {
//                viewModel.conversionHistory = loadedHistory
//            }
//        }
//    }
}

#Preview {
    ContentView()
}

//
//  ConversionHistoryView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

struct ConversionHistoryView: View {
    @Binding var conversionHistory: [ConversionEntry]
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Search by currency", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List(filteredHistory) { entry in
                VStack(alignment: .leading) {
                    Text("\(entry.sourceAmount, specifier: "%.2f") \(entry.sourceCurrency.rawValue) → \(entry.convertedAmount, specifier: "%.2f") \(entry.targetCurrency.rawValue)")
                    Text(entry.timestamp, style: .date)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationBarTitle("Conversion History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") {
                    clearConversionHistory(history: $conversionHistory)
                }
            }
        }
    }
    
    private var filteredHistory: [ConversionEntry] {
        if searchText.isEmpty {
            return conversionHistory
        } else {
            let lowercaseSearchText = searchText.lowercased()
            return conversionHistory.filter { entry in
                let sourceCurrencyMatch = entry.sourceCurrency.rawValue.lowercased().contains(lowercaseSearchText)
                let targetCurrencyMatch = entry.targetCurrency.rawValue.lowercased().contains(lowercaseSearchText)
                return sourceCurrencyMatch || targetCurrencyMatch
            }
        }
    }
    
    func clearConversionHistory(history: Binding<[ConversionEntry]>) {
        history.wrappedValue.removeAll()
    }
}

struct ConversionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let conversionHistory: [ConversionEntry] = []
        return ConversionHistoryView(conversionHistory: .constant(conversionHistory))
    }
}


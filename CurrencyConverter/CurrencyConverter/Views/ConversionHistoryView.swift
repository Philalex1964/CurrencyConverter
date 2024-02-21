//
//  ConversionHistoryView.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import SwiftUI

struct ConversionHistoryView: View {
    @Binding var conversionHistory: [ConversionEntry]
    
    func clearConversionHistory(history: Binding<[ConversionEntry]>) {
        history.wrappedValue.removeAll()
    }
    
    var body: some View {
        List(conversionHistory) { entry in
            VStack(alignment: .leading) {
                Text("\(entry.sourceAmount, specifier: "%.2f") \(entry.sourceCurrency.rawValue) → \(entry.convertedAmount, specifier: "%.2f") \(entry.targetCurrency.rawValue)")
                Text(entry.timestamp, style: .date)
                    .foregroundColor(.secondary)
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
}



struct ConversionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let conversionHistory: [ConversionEntry] = []
               return ConversionHistoryView(conversionHistory: .constant(conversionHistory))
    }
}


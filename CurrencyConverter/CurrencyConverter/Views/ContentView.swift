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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  ConversionEntry.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import Foundation

struct ConversionEntry: Identifiable, Codable, Equatable {
    let id = UUID()
    let sourceCurrency: Currency
    let targetCurrency: Currency
    let sourceAmount: Double
    let convertedAmount: Double
    let timestamp: Date
}

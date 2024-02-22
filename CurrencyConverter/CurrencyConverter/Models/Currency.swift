//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Alexander Filippov on 21.2.24..
//

import Foundation

enum Currency: String, CaseIterable, Codable, Equatable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case chf = "CHF"
    case cny = "CNY"
}



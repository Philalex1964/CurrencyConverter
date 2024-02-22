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
}

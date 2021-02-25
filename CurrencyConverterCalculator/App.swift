//
//  App.swift
//  CurrencyConverterCalculator
//
//  Created by Mustafa Ozhan on 26/07/2020.
//  Copyright © 2020 Mustafa Ozhan. All rights reserved.
//

import SwiftUI
import Trace


@main
struct App: SwiftUI.App {
    
    // MARK: - Property - App
    
    @StateObject var viewModel = AppViewModel()
    private let trace = Trace.shared
    
    
    // MARK: - Property - Scene
    
    var body: some Scene {
        WindowGroup {
            if viewModel.state.isFirstRun {
                CurrenciesView(
                    baseCurrency: $viewModel.state.baseCurrency,
                    isFirstRun: $viewModel.state.isFirstRun
                )
            } else {
                CalculatorView()
            }
        }
    }
}

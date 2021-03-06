//
//  SettingsViewModel.swift
//  CurrencyConverterCalculator
//
//  Created by Mustafa Ozhan on 30/07/2020.
//  Copyright © 2020 Mustafa Ozhan. All rights reserved.
//

import Combine

final class CurrenciesViewModel: ObservableObject, CurrenciesEvent {
    
    // MARK: SEED
    @Published var state = CurrenciesState()
    let effect = PassthroughSubject<CurrenciesEffect, Never>()
    lazy var event = self as CurrenciesEvent
    var data = CurrenciesData()
    
    init() {
        self.initList()
    }
    
    private func initList() {
        state.currencyList = data.coreDataRepository.getAllCurrencies()
        state.isLoading = false
    }
    
    private func getFirstAvaiableBaseCurrencyOrNull() -> CurrencyType {
        return CurrencyType.withLabel(
            self.state.currencyList.filter { $0.isActive == true }.first?.name
        )
    }
    
    private func setBaseCurrency(newBase: CurrencyType) {
        data.defaults.setBaseCurrency(value: newBase)
        effect.send(CurrenciesEffect.changeBaseCurrency(newBase))
    }
    
    // MARK: Event
    func updateAllStates(state: Bool) {
        
        self.state.currencyList.forEach {
            $0.isActive = state
            data.coreDataRepository.updateCurrencyStateByName(name: $0.name, state: state)
        }
        let temp = self.state.currencyList
        self.state.currencyList = temp
        
        if !state {
            setBaseCurrency(newBase: CurrencyType.NULL)
        } else {
            if data.defaults.getBaseCurrency() == CurrencyType.NULL {
                setBaseCurrency(newBase: getFirstAvaiableBaseCurrencyOrNull())
            } else {
                setBaseCurrency(newBase: data.defaults.getBaseCurrency())
            }
        }
    }
    
    func updateState(currency: Currency) {
        state.currencyList.filter { $0.name == currency.name }.first?.isActive = !currency.isActive
        data.coreDataRepository.updateCurrencyStateByName(name: currency.name, state: !currency.isActive)
        
        if CurrencyType.withLabel(currency.name) == data.defaults.getBaseCurrency()
            || data.defaults.getBaseCurrency() == CurrencyType.NULL {
            setBaseCurrency(newBase: getFirstAvaiableBaseCurrencyOrNull())
        } else {
            setBaseCurrency(newBase: data.defaults.getBaseCurrency())
        }
    }
    
    func onDoneClick() {
        if state.currencyList.filter({ $0.isActive == true}).count >= 2 {
            data.defaults.setFirstRun(value: false)
            effect.send(CurrenciesEffect.openCalculator)
        } else {
            effect.send(CurrenciesEffect.warningEffect)
        }
    }
}

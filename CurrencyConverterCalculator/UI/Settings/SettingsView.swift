//
//  SettingsView.swift
//  CurrencyConverterCalculator
//
//  Created by Mustafa Ozhan on 17/08/2019.
//  Copyright © 2019 Mustafa Ozhan. All rights reserved.
//
import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: EnviromentViewModel
    
    var body: some View {
        
        NavigationView {
            Form {
                List {
                    ForEach(0..<viewModel.currencyList.count) { index in
                        SettingsItemView(item: self.$viewModel.currencyList[index])
                    }
                }.listRowBackground(Color("ColorBackground"))
            }.navigationBarItems(
                
                leading: Button(
                    action: { self.viewModel.changeAllStates(state: true) },
                    label: { Text("Select All").foregroundColor(Color("ColorText")) }
                ),
                
                trailing: Button(
                    action: { self.viewModel.changeAllStates(state: false) },
                    label: { Text("Deselect All").foregroundColor(Color("ColorText")) }
                )
                
            ).navigationBarTitle("Settings")
        }.onAppear {
            self.viewModel.initList()
        }
    }
}

#if DEBUG
struct SettingsViewPreviews: PreviewProvider {
    @Environment(\.managedObjectContext) var moc
    
    static var previews: some View {
        SettingsView(viewModel: EnviromentViewModel(moc: SettingsViewPreviews().moc))
        SettingsView(viewModel: EnviromentViewModel(moc: SettingsViewPreviews().moc)).preferredColorScheme(.dark)
    }
}
#endif

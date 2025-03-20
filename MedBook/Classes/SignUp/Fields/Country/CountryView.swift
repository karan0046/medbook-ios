//
//  CountryView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct CountryView: View {
    @Binding var country: String
    @Binding var isValidCountry: Bool
    @StateObject var viewModel = CountryViewModel()
    
    var body: some View {
        VStack {
            Text("Country")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(
                    Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                )
                .padding(.top, 20)
                .padding(.leading, 20)
                .font(.title3)
            
            // write choose country logic here
            if viewModel.loading {
                ProgressView("Loading...")
            } else {
                let sortedCountries = viewModel.countries.sorted(by: { cont1, cont2 in
                    cont1.country < cont2.country
                })
                Picker("Choose your country", selection: $country) {
                    ForEach(sortedCountries, id: \.country) { country in
                        Text(country.country)
                            .foregroundColor(
                                Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                            )
                            .tag(country.country)
                        
                    }
                }
                .frame(width: 0.8*UIScreen.main.bounds.width)
                .pickerStyle(MenuPickerStyle())
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onAppear {
                    if country.isEmpty, !viewModel.currentIPcountry.isEmpty {
                        country = viewModel.currentIPcountry
                        isValidCountry = true
                    }
                }
            }
        }
    }
    
    func isValidCountry(_ name: String) -> Bool {
        return !name.isEmpty
    }
}

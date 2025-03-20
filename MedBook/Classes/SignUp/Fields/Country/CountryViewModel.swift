//
//  CountryViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class CountryViewModel: ObservableObject {
    @Published var countries = [Country]()
    @Published var loading: Bool = false
    @Published var currentIPcountry: String = ""
    
    init() {
        
    }
    
    func fetchData() async {
        loading = true
        guard let url = URL(string: "https://api.first.org/data/v1/countries") else {
            loading = false
            print("invalid url")
            return
        }
        // cache country ni local db data from api and use it again if in case of sign up again
        let countryListData = await Table.Country.fetchAll(filters: nil, sortBy: nil, offset: nil, limit: nil)
        guard countryListData.isEmpty else {
            countries.removeAll()
            countryListData.forEach { country in
                countries.append(Country(json: country))
            }
            loading = false
            return
        }
        let (responseStatus, _, data, _) = await API(url).execute()
        guard let result = data as? [String: Any], let countriesData = result["data"] as? [String: Any] else {
            print(responseStatus)
            return
        }
        countries.removeAll()
        countriesData.forEach { (key, value) in
            guard let countryDetails = value as? [String: Any], let name = countryDetails["country"] as? String, let region = countryDetails["region"] as? String else { return }
            let country = Country(isoCode: key, country: name, region: region)
            countries.append(country)
            Task {
                await Table.Country.insert(withJson: country.toDic(), docId: country.isoCode) { success, error in
                    guard success else {
                        print(error as Any)
                        return
                    }
                }
            }
        }
        loading = false
    }
    
    func fetchIPCountry() async {
        loading = true
        // save IpCountry in USerDaefaults and use it next-for-time
        if let savedCountry = UserDefaults.standard.string(forKey: "IpCountry") {
            currentIPcountry = savedCountry
            loading = false
            return
        }
        
        guard let url = URL(string: "http://ip-api.com/json") else {
            loading = false
            print("invalid url")
            return
        }
        let (responseStatus, _, data, _) = await API(url).execute()
        guard let result = data as? [String: Any], let name = result["country"] as? String else {
            print(responseStatus)
            return
        }
        currentIPcountry = name
        UserDefaults.standard.set(name, forKey: "IpCountry")
        loading = false
    }
    
    deinit {
        print("CountryViewModel deallocated")
    }
}

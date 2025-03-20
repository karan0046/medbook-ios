//
//  Country.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

struct Country: Hashable {
    var isoCode: String
    var country: String
    var region: String

    init(isoCode: String, country: String, region: String) {
        self.isoCode = isoCode
        self.country = country
        self.region = region
    }

    init(json: [String: Any]) {
        self.isoCode = json["isoCode"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
        self.region = json["region"] as? String ?? ""
    }

    func toDic() -> [String: Any] {
        return [
            "isoCode": isoCode,
            "country": country,
            "region": region
        ]
    }
}

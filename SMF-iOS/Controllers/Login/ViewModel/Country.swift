//
//  Country.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import Foundation

class Country: Codable {
    
    var id: String = ""
    var title: String = ""
    var name: String = ""
    var iso2: String = ""
    var dialCode: String = ""
    var priority: Int = 0
    var areaCodes: [String]?
    
    init(name: String, iso2: String) {
        self.id = iso2
        self.name = name
        self.iso2 = iso2
        
        if let country = self.getCountry(forCountryCode: iso2) {
            self.dialCode = country.dialCode
            self.priority = country.priority
            self.areaCodes = country.areaCodes
        }
        
        self.title = "\(name)  (\(String(describing: dialCode)))"
    }
    
    required init() {
        
    }
    
    enum CodingKeys : String, CodingKey {
        case name
        case iso2
        case dialCode
        case priority
        case areaCodes
    }
    
    static func getCountries() -> [Country] {
        
        let url = Bundle.main.url(forResource: "CountryCodeFlag", withExtension: "json")
        
        guard let jsonData = url, let data = try? Data(contentsOf: jsonData) else {
            return []
        }
        
        guard let countries: [Country] = try? JSONDecoder().decode([Country].self, from: data) else {
            print("Could not parse json response")
            return []
        }
        return countries
    }
    
    static func flag(forCountryCode iso2: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in iso2.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try? container.decode(String.self, forKey: CodingKeys.name)
        let dialCode = try? container.decode(String.self, forKey: CodingKeys.dialCode)
        let iso2 = try? container.decode(String.self, forKey: CodingKeys.iso2)
        let priority = try? container.decode(Int.self, forKey: CodingKeys.priority)
        self.areaCodes = try? container.decode([String].self, forKey: CodingKeys.areaCodes)
        
        self.name = name ?? ""
        self.iso2 = iso2 ?? ""
        self.priority = priority ?? 0
        self.dialCode = dialCode ?? ""
        self.id = self.iso2
        self.title = "\(self.name)  (\(self.dialCode))"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(dialCode, forKey: CodingKeys.dialCode)
        try container.encode(iso2, forKey: CodingKeys.iso2)
        try container.encode(priority, forKey: CodingKeys.priority)
        try container.encode(areaCodes, forKey: CodingKeys.areaCodes)
    }
    
    
    func getCountry(forCountryCode iso2: String) -> Country? {
        if let country = (Country.getCountries().filter {$0.iso2 == iso2}).first {
            return country
        }
        return nil
    }
    
    //NEWIOSCOMM-803
    static func getCountryISO2(forCountryName name: String) -> String? {
        if let country = (Country.getCountries().filter {$0.name.hasPrefix(name)}).first {
            return country.iso2
        }
        return nil
    }
}

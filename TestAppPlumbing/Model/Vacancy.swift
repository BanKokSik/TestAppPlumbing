//
//  Model.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 14.11.2023.
//

import Foundation

// MARK: - Vacancy
struct Vacancy: Decodable {
    internal init(id: String, name: String, area: Area, salary: Salary, address: Address? = nil, employer: Employer, snippet: Snippet, professionalRoles: [ProfessionalRole]) {
        self.id = id
        self.name = name
        self.area = area
        self.salary = salary
        self.address = address
        self.employer = employer
        self.snippet = snippet
        self.professionalRoles = professionalRoles
    }
    
    let id, name: String
    let area: Area?
    let salary: Salary?
    let address: Address?
    let employer: Employer?
    let snippet: Snippet?
    let professionalRoles: [ProfessionalRole]?

    enum CodingKeys: String, CodingKey {
        case id, name, area, salary, address, employer, snippet
        case professionalRoles = "professional_roles"
    }

    static var placeholder: Vacancy {
        Vacancy(id: "",
                name: "",
                area: Area(id: "", name: "", url: ""),
                salary: Salary(from: 1, to: 100, currency: ""),
                address: nil,
                employer: Employer(id: "",
                                   name: "",
                                   logoUrls: LogoUrls(the90: "", the240: "", original: "")),
                snippet: Snippet(requirement: "", responsibility: ""),
                professionalRoles: [])
    }
}

// MARK: - Address
struct Address: Decodable {
    let raw: String?
    let id: String?
}

// MARK: - Area
struct Area: Decodable {
    let id: String?
    let name: String?
    let url: String?
}

// MARK: - Employer
struct Employer: Decodable {
    let id: String?
    let name: String?
    let logoUrls: LogoUrls?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoUrls = "logo_urls"
    }
}

// MARK: - LogoUrls
struct LogoUrls: Decodable {
    let the90: String?
    let the240: String?
    let original: String?

    enum CodingKeys: String, CodingKey {
        case the90 = "90"
        case the240 = "240"
        case original
    }
}

// MARK: - ProfessionalRole
struct ProfessionalRole: Decodable {
    let id: String?
    let name: String?
}

// MARK: - Salary
struct Salary: Decodable {
    let from: Int?
    let to: Int?
    let currency: String?
}

// MARK: - Snippet
struct Snippet: Decodable {
    let requirement: String?
    let responsibility: String?
}

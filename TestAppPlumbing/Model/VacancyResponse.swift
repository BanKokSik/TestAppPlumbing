//
//  VacancyResponse.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 17.11.2023.
//

import Foundation

struct VacancyResponse: Decodable {
    let items: [Vacancy]

    static let placeholder: VacancyResponse = .init(items: [])

    init(items: [Vacancy]) {
        self.items = items
    }

    enum CodingKeys: CodingKey {
        case items
    }
}

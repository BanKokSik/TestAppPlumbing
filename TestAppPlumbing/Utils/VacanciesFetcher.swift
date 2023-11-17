//
//  LoadData.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 16.11.2023.
//

import Foundation
import Combine

class VacanciesFetcher{
    private let api = "https://api.hh.ru/vacancies"
    
    static let shared = VacanciesFetcher()
    
    private init(){}
    
    private func absoluteURL(search: String) -> URL? {
        guard let queryURL = URL(string: api),
              var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        components.queryItems = [URLQueryItem(name: "text", value: search),
                                 URLQueryItem(name: "searchField", value: "vacancy")]
        return components.url
    }
    
    func getVacancies(_ search: String) -> AnyPublisher <VacancyResponse, Never> {
        guard let url = absoluteURL(search: search)
        else {
            return Just(VacancyResponse.placeholder)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for:url)
            .map { $0.data }
            .decode(type: VacancyResponse.self, decoder: JSONDecoder())
            .catch { error in Just(VacancyResponse.placeholder) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
}


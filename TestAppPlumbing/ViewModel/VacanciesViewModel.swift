//
//  VacanciesViewModel.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 16.11.2023.
//

import Foundation
import Combine

final class VacanciesViewModel {
    
    @Published private (set) var vacancies = [Vacancy]()
    @Published var searchText = ""

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        $searchText
            .filter {$0.count >= 3}
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .flatMap { (searchText:String) -> AnyPublisher <VacancyResponse, Never> in
                VacanciesFetcher.shared.getVacancies(searchText)
            }
            .compactMap { response in
                return response.items
            }
            .assign(to: \.vacancies, on: self)
            .store(in: &self.cancellableSet)
    }
}

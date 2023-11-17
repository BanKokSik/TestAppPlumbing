//
//  VacanciesViewController.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 14.11.2023.
//

import UIKit
import SnapKit
import Combine

final class VacanciesTableViewController: UITableViewController {
    
    private var vacancies = [Vacancy]()
    private let viewModel = VacanciesViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var searchBarTextIsEmpty: Bool {
        guard let text = searchController.searchBar.text
        else {
            return false
        }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarTextIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurateSearchControl()
        configurateTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$vacancies.sink { [weak self] vacancies in
            self?.vacancies = vacancies
            self?.tableView.reloadData()
        }.store(in: &self.cancellableSet)
    }
    
    private func configurateSearchControl() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func configurateTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VacanciesTableViewCell.self, forCellReuseIdentifier: VacanciesTableViewCell.id)
    }
}

extension VacanciesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text
        else {
            return
        }
        viewModel.searchText = text
    }
}

extension VacanciesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VacanciesTableViewCell.id) as? VacanciesTableViewCell
        else {
            return UITableViewCell()
        }
        let vacancy = vacancies[indexPath.row]
        cell.configCell(vacancy: vacancy)
        return cell
    }
}


//
//  VacanciesTableViewCell.swift
//  TestAppPlumbing
//
//  Created by Nikita Chekmarev on 15.11.2023.
//

import UIKit
import SnapKit

class VacanciesTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let id = "VacanciesCell"
    
    private lazy var vacancyName: UILabel = {
        let name = UILabel()
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var salary: UILabel = {
        let salary = UILabel()
        salary.lineBreakMode = .byWordWrapping
        salary.numberOfLines = 0
        return salary
    }()
    
    private lazy var companyName: UILabel = {
        let name = UILabel()
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = 0
        return name
    }()
    
    private let companyLogo: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var requirements: UILabel = {
        let requirements = UILabel()
        requirements.lineBreakMode = .byWordWrapping
        requirements.numberOfLines = 0
        return requirements
    }()
    
    private lazy var responsibilities: UILabel = {
        let responsibilities = UILabel()
        responsibilities.lineBreakMode = .byWordWrapping
        responsibilities.numberOfLines = 0
        return responsibilities
    }()
    
    private func setupConstraints() {
        vacancyName.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalTo(companyLogo.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(2)
        }
        salary.snp.makeConstraints { make in
            make.leading.equalTo(vacancyName.snp.trailing).offset(10)
            make.top.equalTo(companyLogo.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(5)
        }
        companyLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.size.equalTo(100)
        }
        companyName.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        requirements.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(vacancyName.snp.bottom).offset(15)
        }
        responsibilities.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(requirements.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func addSubview() {
        contentView.addSubview(vacancyName)
        contentView.addSubview(salary)
        contentView.addSubview(companyName)
        contentView.addSubview(companyLogo)
        contentView.addSubview(responsibilities)
        contentView.addSubview(requirements)
    }
    
    private func configLogo(vacancy: Vacancy) {
        if let logoURL = vacancy.employer?.logoUrls?.the240, let url = URL(string: logoURL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.companyLogo.image = image
                        }
                    }
                }
            }
        }
    }
    
    private func configSalary(vacancy: Vacancy) {
        var salary = "Зарплата: "
        if let from = vacancy.salary?.from {
            salary.append("от \(from) ")
        }
        if let to = vacancy.salary?.to {
            salary.append("до \(to) ")
        }
        if let cur = vacancy.salary?.currency {
            salary.append(cur)
        }
        self.salary.text = salary
    }
    
    func configCell(vacancy: Vacancy) {
        vacancyName.text = ("Должность:\n \(vacancy.name)")
        if let req = vacancy.snippet?.requirement {
            requirements.text = ("Требования:\n \(req)")
        }
        if let res = vacancy.snippet?.responsibility {
            responsibilities.text = ("Обязанности:\n \(res)")
        }
        if let vac = vacancy.employer?.name {
            companyName.text = ("Компания:\n \(vac)")
        }
         
        configSalary(vacancy: vacancy)
        configLogo(vacancy: vacancy)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vacancyName.text = nil
        salary.text = nil
        requirements.text = nil
        responsibilities.text = nil
        companyName.text = nil
        companyLogo.image = nil
    }
}

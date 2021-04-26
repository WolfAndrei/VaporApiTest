//
//  AcronymCell.swift
//  VaporApiTest
//
//  Created by Andrei Volkau on 26.04.2021.
//

import UIKit

class AcronymCell: UITableViewCell {
    static let cellId = "AcronymCell"
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func set(acronym: Acronym) {
        titleLabel.text = acronym.short
        detailLabel.text = acronym.long
    }
    
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

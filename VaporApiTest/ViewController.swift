//
//  ViewController.swift
//  VaporApiTest
//
//  Created by Andrei Volkau on 26.04.2021.
//

import UIKit

class ViewController: UIViewController, Parsing, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let parser = NetworkParser(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        parser.parseDelegate = self
        
        parser.parse()
    }
    
    //MARK: - UI
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(AcronymCell.self, forCellReuseIdentifier: AcronymCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = rc
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        parser.parse()
    }
    
    //MARK: - Protocol conformance
    
    //MARK: - Parsing
    
    func receiveError(err: Error) {
        print(err.localizedDescription)
    }
    
    var acronyms: [Acronym] = []
    
    func receiveData(data: Any) {
        guard let data = data as? [[String: Any]] else {
            print(DataError.corruptedData)
            return
        }
        for acr in data {
            guard let id = acr["id"] as? String,
                  let short = acr["short"] as? String,
                  let long = acr["long"] as? String else {
                print(DataError.corruptedData)
                return
            }
            
            let acronym = Acronym(id: id, short: short, long: long)
            if !acronyms.contains(acronym) {
                acronyms.append(acronym)
            }
        }
        if let rc = tableView.refreshControl,
           rc.isRefreshing {
            rc.endRefreshing()
        }
        tableView.reloadData()
    }
    
    //MARK: - Table View delegate && data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acronyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AcronymCell.cellId) as! AcronymCell
        cell.set(acronym: acronyms[indexPath.row])
        return cell
    }
    
    
}


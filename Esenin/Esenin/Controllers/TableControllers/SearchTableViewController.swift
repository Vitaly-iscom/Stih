//
//  SearchTableViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 12/11/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit

final class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - variables
    private var searchController: UISearchController!
    private var searchResult = [String]()
    private var readFromFile = ReadFromFile()
    private let yellowColor = Constants.shared.yellowColor
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readFromFile.readFrom(title: "AllTitle", description: "AllDesc", body: "AllBody")
        tableView.separatorStyle = .none
        
        setupNavBar()
        setupSearchController()
        configureSearchBar()
    }
    
    //MARK: - methods for viewDidLoad
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        definesPresentationContext = true
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
    }
    
    private func configureSearchBar() {
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти стихотворение"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.barTintColor = yellowColor
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.searchBar.backgroundColor = yellowColor
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        searchController.isActive = false
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = searchResult[indexPath.row]
        
        return cell
    }
    
    //MARK: - search methods
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }
    
    private func filterContent(searchText: String) {
        searchResult = readFromFile.titlePoems.filter({(poem: String) -> Bool in
            let title = poem.range(of: searchText, options: .caseInsensitive)
            return title != nil
        })
    }
    
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? SearchViewController else { return }
                if searchController.isActive {
                    let index = readFromFile.titlePoems.indexOf(x: searchResult[indexPath.row])
                    dvc.poemItems.titlePoems = readFromFile.titlePoems[index!]
                    dvc.poemItems.body = readFromFile.bodyPoems[index!]
                    dvc.poemItems.desc = readFromFile.descPoems[index!]
                    dvc.poemItems.like = readFromFile.like[index!]
                } else {
                    dvc.poemItems.titlePoems = readFromFile.titlePoems[indexPath.row]
                    dvc.poemItems.body = readFromFile.bodyPoems[indexPath.row]
                    dvc.poemItems.desc = readFromFile.descPoems[indexPath.row]
                    dvc.poemItems.like = readFromFile.like[indexPath.row]
                }
            }
        }
    }
}

//MARK: - extention
extension Array {
    func indexOf<T : Equatable>(x: T) -> Int? {
        for i in 0..<self.count {
            if self[i] as! T == x {
                return i
            }
        }
        return nil
    }
}

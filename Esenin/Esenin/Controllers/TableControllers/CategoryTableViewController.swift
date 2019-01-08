//
//  CategoryTableViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 22.10.2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit

final class CategoryTableViewController: UITableViewController {
    
    //MARK: - variables
    private let category = Constants.shared.category
    private let categoryName = Constants.shared.categoryName

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = categoryName[indexPath.row]
        cell.textLabel?.textAlignment = .center

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? TitleCategoryViewController else { return }
                dvc.nameFile = category[indexPath.row]
                dvc.titleForView = categoryName[indexPath.row]
            }
        }
    }
}

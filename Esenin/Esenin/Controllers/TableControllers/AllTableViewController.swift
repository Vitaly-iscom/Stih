//
//  ViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 11.10.2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit
import CoreData

final class AllTableViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - variables
    private var readFromFile = ReadFromFile()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readFromFile.readFrom(title: "AllTitle", description: "AllDesc", body: "AllBody")
        tableView.separatorStyle = .none
    }
}

//MARK: - extensions
extension AllTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readFromFile.titlePoems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = readFromFile.titlePoems[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! AllPoemsViewController
                
                dvc.poemItems.titlePoems = readFromFile.titlePoems[indexPath.row]
                dvc.poemItems.body = readFromFile.bodyPoems[indexPath.row]
                dvc.poemItems.desc = readFromFile.descPoems[indexPath.row]
                dvc.poemItems.like = readFromFile.like[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


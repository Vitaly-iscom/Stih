//
//  FavoritesTableViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 29/10/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit
import CoreData

final class FavoritesTableViewController: UITableViewController {
    
    //MARK: - variables
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var poems = [Poems]()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fetchRequest: NSFetchRequest<Poems> = Poems.fetchRequest()
        
        do {
            let poems = try context.fetch(fetchRequest)
            self.poems = poems
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = poems[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? FavoritesViewController else { return }
                dvc.poemItems.titlePoems = poems[indexPath.row].title
                dvc.poemItems.desc = poems[indexPath.row].desc
                dvc.poemItems.body = poems[indexPath.row].body
            }
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            context.delete(poems[indexPath.row])
            poems.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        default: return
        }
    }
}

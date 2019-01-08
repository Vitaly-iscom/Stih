//
//  TestViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 22.10.2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit

final class TitleCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - variables
    public var nameFile: String?
    private var readFromFile = ReadFromFile()
    public var titleForView: String?

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let nameFile = nameFile else { return }
        readFromFile.readFrom(title: "\(nameFile)" + "Title", description: "\(nameFile)" + "Desc", body: "\(nameFile)" + "Body")
        
        createBackButton()
        createTitle()
        
    }
    
    //MARK: - Methods
    fileprivate func createBackButton() {
        let image = UIImage(named: "Chevron")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backAction(param:)))
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    @objc func backAction(param: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func createTitle() {
        if titleForView == "Лучшие" || titleForView == "Филосовские" || titleForView == "Хулиганские" || titleForView == "Грустные" {
            guard let title = titleForView else {return}
            self.title = title + " " + "cтихи"
        } else {
            guard let title = titleForView else {return}
            self.title = "Стихи" + " " + title.firstUppercased
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readFromFile.titlePoems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = readFromFile.titlePoems[indexPath.row]
        
        return cell
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! CategoryViewController

                dvc.poemItems.titlePoems = readFromFile.titlePoems[indexPath.row]
                dvc.poemItems.body = readFromFile.bodyPoems[indexPath.row]
                dvc.poemItems.desc = readFromFile.descPoems[indexPath.row]
                dvc.poemItems.like = readFromFile.like[indexPath.row]
            }
        }
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extention
extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst()
    }
}

//
//  CategoryViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 29/10/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit
import CoreData

final class CategoryViewController: UIViewController {
    
    //MARK: - variables for CoreData
    lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //MARK: - IBOutlets
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //MARK: - variables
    public var poems = [Poems]()
    let yellowColor = Constants.shared.yellowColor
    public var poemItems = PoemItems.shared
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let fetchRequest: NSFetchRequest<Poems> = Poems.fetchRequest()
        do {
            let poems = try context.fetch(fetchRequest)
            self.poems = poems
        } catch {
            print(error.localizedDescription)
        }
        
        poemItems.like = false
        for i in poems {
            guard let item = i.title else {return}
            if item == poemItems.titlePoems {
                self.poemItems.like = true
                self.likeButton.image = UIImage(named: "LikeRed")
                self.likeButton.tintColor = .red
            }
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = poemItems.titlePoems
        textView.text = poemItems.body
        if poemItems.desc != nil {
            descriptionLabel.text = poemItems.desc
        }
        
        if poemItems.like! {
            self.likeButton.image = UIImage(named: "LikeRed.png")
            self.likeButton.tintColor = .red
        } else {
            self.likeButton.image = UIImage(named: "LikeBlack.png")
            self.likeButton.tintColor = .black
        }
        navigationBar.barTintColor = yellowColor
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //MARK: - IBActions
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeAction(_ sender: UIBarButtonItem) {
        
        poemItems.like = !poemItems.like!
        if poemItems.like! {
            
            let entity = NSEntityDescription.entity(forEntityName: "Poems", in: context)
            let poem = NSManagedObject(entity: entity!, insertInto: context)
            
            poem.setValue(poemItems.titlePoems, forKey: "title")
            poem.setValue(poemItems.desc, forKey: "desc")
            poem.setValue(poemItems.body, forKey: "body")
            poem.setValue(poemItems.like, forKey: "like")
            
            self.likeButton.image = UIImage(named: "LikeRed.png")
            self.likeButton.tintColor = .red
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Poems")
            do {
                let result = try context.fetch(request)
                for data in result as! [Poems] {
                    if data.title == poemItems.titlePoems {
                        context.delete(data)
                        try context.save()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            self.likeButton.image = UIImage(named: "LikeBlack.png")
            self.likeButton.tintColor = .black
        }
    }
}

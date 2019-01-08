//
//  SearchViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 12/11/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit
import CoreData

final class SearchViewController: UIViewController {
    
    //MARK: - variables for CoreData
    lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - variables
    public var poemItems = PoemItems.shared
    private var poems = [Poems]()
    private var likeButton = UIBarButtonItem()
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
        
        createBackButton()
        createLikeButton()
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //MARK: - Methods
    private func createBackButton() {
        let image = UIImage(named: "Chevron")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backAction(param:)))
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    @objc func backAction(param: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createLikeButton() {

        if poemItems.like! {
            guard let image = UIImage(named: "LikeRed.png") else {return}
            likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeAction(param:)))
            likeButton.tintColor = .red
        } else {
            guard let image = UIImage(named: "LikeBlack.png") else {return}
            likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeAction(param:)))
            likeButton.tintColor = .black
        }
        
        navigationItem.setRightBarButton(likeButton, animated: true)
    }
    
    @objc func likeAction(param: UIBarButtonItem) {
        
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

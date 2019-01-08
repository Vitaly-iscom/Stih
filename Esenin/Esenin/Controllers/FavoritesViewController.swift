//
//  FavoritesViewController.swift
//  Esenin
//
//  Created by Виталий Исхаков on 30/10/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - variables
    public var poemItems = PoemItems.shared
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
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
}

//
//  WebViewController.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var htmlString = ""
    var article = ""
    var people = [Person]()
    var svaedArticle = [Person]()
//    var article:ArticleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let url = URL(string: htmlString)
        let requestObj = URLRequest(url: url! as URL)
        webView.load(requestObj)
        view = webView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTap))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.svaedArticle = people
        } catch {}
    }
    
    @objc func saveTap() {
        guard !svaedArticle.contains(where: {$0.url == htmlString}) else {
            let alert = UIAlertController(title: "Article already added to favorites", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return }
        
        let alert = UIAlertController(title: "Add this article to favorite", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            let person = Person(context: PersistenceServce.context)
            person.url = self.htmlString
            person.title = self.article
            PersistenceServce.saveContext()
            self.people.append(person)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            print("cancel")
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

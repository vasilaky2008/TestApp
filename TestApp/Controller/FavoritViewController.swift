//
//  FavoritViewController.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class FavoritViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
        } catch {}
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            guard let webVC = segue.destination as? WebViewController else { return }
            let sender = sender as! Person
            webVC.article = sender.title!
            webVC.htmlString = sender.url!
        }
    }
}

extension FavoritViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.accessoryType = .none
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = people[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  article = people[indexPath.row]
        self.performSegue(withIdentifier: "webViewSegue", sender: article)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Are you sure you want to remove this article from your favorites", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (_) in
                PersistenceServce.context.delete(self.people[indexPath.row])
                self.people.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
                print("cancel")
            }
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
}



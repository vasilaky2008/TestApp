//
//  MostSharedViewController.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MostSharedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    var article:[ArticleModel]?
    let alert = AlertMessage.sharedAlert
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = view.center
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl) // not required when using UITableViewController
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    @objc func refresh(sender:AnyObject) {
        getArticles()
    }
    
    func getArticles() {
        activityIndicator.startAnimating()
        AF.request("https://api.nytimes.com/svc/mostpopular/v2/shared/30/facebook.json?api-key=ktAvGH6DQIpXAZyyGb3qIGezp5d8A3NJ", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                switch response.result {
                case .success(let json):
                    DispatchQueue.main.async {
                        let json = JSON(json)
                        let article = json["results"].arrayValue.map { ArticleModel(with: $0) }
                        self.article = article
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    self.article?.removeAll()
                    self.alert.showAlert(title: "Error", message: error.errorDescription ?? "Error")
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            guard let webVC = segue.destination as? WebViewController else { return }
            let sender = sender as! ArticleModel
            webVC.article = sender.title
            webVC.htmlString = sender.url
        }
    }
}

extension MostSharedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.accessoryType = .none
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = article?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = article?[indexPath.row] else {return}
        self.performSegue(withIdentifier: "webViewSegue", sender: article)
    }
}

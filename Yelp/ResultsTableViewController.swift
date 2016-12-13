//
//  ResultsTableViewController.swift
//  moodmaps
//
//  Created by Shreenithi Narayanan on 12/7/16.
//  Copyright © 2016 Shreenithi Narayanan. All rights reserved.
//

import UIKit
import Appz

class ResultsTableViewController: UITableViewController {
    
    var results: [String: String] = [:]
    let apps = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        results = MoodViewController.getResults();
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = Array(results.keys)[indexPath.row]
        cell.textLabel?.text = key
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.init(red: 155/255, green: 89/255, blue: 182/255, alpha: 1);
        } else {
            cell.backgroundColor = UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1);
        }
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Thin", size: 20)
        cell.textLabel?.textColor = UIColor.white;
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = Array(results.values)[indexPath.row]
        apps.open(Applications.Yelp(), action: .business(id: value))
    }

}

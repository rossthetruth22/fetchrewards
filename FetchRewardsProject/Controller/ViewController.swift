//
//  ViewController.swift
//  FetchRewards
//
//  Created by Royce Reynolds on 10/3/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var listDict = [Int:[ListId]]()
    var listSect = [Int]()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let fetch = FetchService.sharedInstance()
        
        let _ = fetch.getDataMethod { (data, error) in
            self.listDict = data
            self.listSect = ListId.getSortedKeys(self.listDict)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

}


extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listSect.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDict[listSect[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        let list = listDict[listSect[indexPath.section]]![indexPath.row]
    
        cell.textLabel?.text = String(list.id)
        cell.detailTextLabel?.text = list.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List ID: \(listSect[section])"
    }
    
    
    
    
}

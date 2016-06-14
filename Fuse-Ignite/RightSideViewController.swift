//
//  RightSideViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 15/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class RightSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        
        myCell.textLabel?.text = searchResults[(indexPath as NSIndexPath).row]
        
        return myCell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        let eventNameQuery = PFQuery(className: "EventObject")
        eventNameQuery.whereKey("eventName", matchesRegex: "(?i)\(searchBar.text)")
        
        let eventDescriptionQuery = PFQuery(className: "EventObject")
        eventNameQuery.whereKey("eventDescription", matchesRegex: "(?i)\(searchBar.text)")
        
        let eventLocationQuery = PFQuery(className: "EventObject")
        eventNameQuery.whereKey("eventLocation", matchesRegex: "(?i)\(searchBar.text)")
    
        let query = PFQuery.orQuery(withSubqueries: [eventNameQuery,eventDescriptionQuery,eventLocationQuery])
        
        query.findObjectsInBackground { (results: [PFObject]?, error: NSError?) -> Void in
            
            if(error != nil)
            {
                let userMessage:String = error!.localizedDescription
                self.displayMessage(userMessage)
            }
            
            if let objects = results {
                self.searchResults.removeAll(keepingCapacity: false)
                
                for object in objects {
                    let eventName = object.object(forKey: "eventName") as! String
                    _ = object.object(forKey: "eventDescription") as! String
                    _ = object.object(forKey: "eventLocation") as! String

                    self.searchResults.append(eventName)
                }
                
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                    self.searchBar.resignFirstResponder()
                    
                }
            }
        }
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
   
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchResults.removeAll(keepingCapacity: false)
        searchTable.reloadData()
        
    }
    
    func displayMessage(_ userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    
}

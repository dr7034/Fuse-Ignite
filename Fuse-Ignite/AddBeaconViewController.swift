//
//  AddBeaconViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 17/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import CoreLocation

class AddBeaconViewController: UITableViewController {
    @IBOutlet weak var saveBarButtonItem: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var majorIdTextField: UITextField!
    @IBOutlet weak var minorIdTextField: UITextField!
    
    var uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .CaseInsensitive)
    var nameFieldValid = false
    var UUIDFieldValid = false
    var newItem: BeaconItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButtonItem.enabled = false
        
        nameTextField.addTarget(self, action: #selector(AddBeaconViewController.nameTextFieldChanged(_:)), forControlEvents: .EditingChanged)
        uuidTextField.addTarget(self, action: #selector(AddBeaconViewController.uuidTextFieldChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    func nameTextFieldChanged(textField: UITextField) {
        nameFieldValid = (textField.text!.characters.count > 0)
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid)
    }
    
    func uuidTextFieldChanged(textField: UITextField) {
        let numberOfMatches = uuidRegex.numberOfMatchesInString(textField.text!, options: [], range: NSMakeRange(0, textField.text!.characters.count))
        UUIDFieldValid = (numberOfMatches > 0)
        
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveItemSegue" {
            let uuid = NSUUID(UUIDString: uuidTextField.text!)
            let major: CLBeaconMajorValue = UInt16(Int(majorIdTextField.text!)!)
            let minor: CLBeaconMinorValue = UInt16(Int(minorIdTextField.text!)!)
            
            newItem = BeaconItem(name: nameTextField.text!, uuid: uuid!, majorValue: major, minorValue: minor)
        }
    }
}

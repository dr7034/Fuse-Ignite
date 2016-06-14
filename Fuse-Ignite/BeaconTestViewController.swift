//
//  BeaconTestViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 10/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconTestViewController: UIViewController, ESTBeaconManagerDelegate {
    
    @IBOutlet weak var beaconNameLabel: UILabel!

    
    let beaconManager: ESTBeaconManager = ESTBeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconManager.delegate = self
        
//        let beacon1Region = CLBeaconRegion(
//            proximityUUID: NSUUID(UUIDString: "712CCB65-D5C3-047E-9CF3-E3A683026081")!,
//            identifier: "Ignite0")
//        
        
    }
    
    
    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
        
    }
    
    
    
}

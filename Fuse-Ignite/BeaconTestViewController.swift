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
        
        let beacon1Region = CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "712CCB65-D5C3-047E-9CF3-E3A683026081")!,
            identifier: "Ignite0")
        
        self.beaconManager.startRangingBeaconsInRegion(beacon1Region)
    }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
}
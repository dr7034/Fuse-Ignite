//
//  BeaconItem.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 17/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import Foundation
import CoreLocation

struct BeaconItemConstant {
    static let nameKey = "name"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
}

class BeaconItem: NSObject, NSCoding {
    let name: String
    let uuid: NSUUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    dynamic var lastSeenBeacon: CLBeacon?
    
    init(name: String, uuid: NSUUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        if let aName = aDecoder.decodeObjectForKey(BeaconItemConstant.nameKey) as? String {
            name = aName
        }
        else {
            name = ""
        }
        if let aUUID = aDecoder.decodeObjectForKey(BeaconItemConstant.uuidKey) as? NSUUID {
            uuid = aUUID
        }
        else {
            uuid = NSUUID()
        }
        majorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconItemConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconItemConstant.minorKey))
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: BeaconItemConstant.nameKey)
        aCoder.encodeObject(uuid, forKey: BeaconItemConstant.uuidKey)
        aCoder.encodeInteger(Int(majorValue), forKey: BeaconItemConstant.majorKey)
        aCoder.encodeInteger(Int(minorValue), forKey: BeaconItemConstant.minorKey)
    }
    
}

func == (item: BeaconItem, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.UUIDString == item.uuid.UUIDString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}


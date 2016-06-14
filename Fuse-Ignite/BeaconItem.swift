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
    let uuid: UUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    dynamic var lastSeenBeacon: CLBeacon?
    
    init(name: String, uuid: UUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        if let aName = aDecoder.decodeObject(forKey: BeaconItemConstant.nameKey) as? String {
            name = aName
        }
        else {
            name = ""
        }
        if let aUUID = aDecoder.decodeObject(forKey: BeaconItemConstant.uuidKey) as? UUID {
            uuid = aUUID
        }
        else {
            uuid = UUID()
        }
        majorValue = UInt16(aDecoder.decodeInteger(forKey: BeaconItemConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: BeaconItemConstant.minorKey))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: BeaconItemConstant.nameKey)
        aCoder.encode(uuid, forKey: BeaconItemConstant.uuidKey)
        aCoder.encode(Int(majorValue), forKey: BeaconItemConstant.majorKey)
        aCoder.encode(Int(minorValue), forKey: BeaconItemConstant.minorKey)
    }
    
}

func == (item: BeaconItem, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}


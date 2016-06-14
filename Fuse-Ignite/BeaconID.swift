//
//  BeaconID.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 09/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

struct BeaconID: Equatable, CustomStringConvertible, Hashable {
    
    let proximityUUID: UUID
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    
    init(proximityUUID: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
    }
    
    init(UUIDString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) {
        self.init(proximityUUID: UUID(uuidString: UUIDString)!, major: major, minor: minor)
    }
    
    var asString: String {
        get { return "\(proximityUUID.uuidString):\(major):\(minor)" }
    }
    
    var asBeaconRegion: CLBeaconRegion {
        get { return CLBeaconRegion(
            proximityUUID: self.proximityUUID, major: self.major, minor: self.minor,
            identifier: self.asString) }
    }
    
    var description: String {
        get { return self.asString }
    }
    
    var hashValue: Int {
        get { return self.asString.hashValue }
    }
    
}

func ==(lhs: BeaconID, rhs: BeaconID) -> Bool {
    return lhs.proximityUUID == rhs.proximityUUID
        && lhs.major == rhs.major
        && lhs.minor == rhs.minor
}

extension CLBeacon {
    
    var beaconID: BeaconID {
        get { return BeaconID(
            proximityUUID: proximityUUID,
            major: major.uint16Value,
            minor: minor.uint16Value) }
    }
    
}

//
//  Flight.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/2/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class Flight {
    
    //Testing the waters
    var grossWeight: Double = 0.0
    var wingSweep: Bool = false //wing sweep true = 15 WS or 20 WS
                                //wing sweep false = 20 WS SEF/SIS OFF
    var fieldLength: Double = 0.0
    var pressureAltitude: Double = 0.0
    var temperature: Double = 0.0   //teperature in ºF
    var rCR: Double = 0.0
    
    var refusalSpeedFactor: Double = 0.0
    var refusalSpeed: Double = 0.0
    var decisionSpeed: Double = 0.0
    var rotateSpeed: Double = 0.0
    var takeoffSpeed: Double = 0.0
    var breakCaution: Double = 0.0
    var breakDanger: Double = 0.0
    var takeOffDistance: Double = 0.0
    var cFL: Double = 0.0
    
}

//
//  Flight.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/2/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class Flight {
    
    var grossWeight: Double = 0.0
    var wingSweep: Bool = true //wing sweep true = 15 WS or 20 WS
                                //wing sweep false = 20 WS SEF/SIS OFF
    var fieldLength: Double = 0.0
    var pressureAltitude: Double = 0.0
    var temperature: Double = 0.0   //temperature in ºF
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
    
    func setTemperature (temp: String, cORf: Int) -> Double {

        var tempF: Double = 0.0
        var tempString = temp
        var tempDouble: Double = 0.0
        
        tempString = tempString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        tempDouble = Double(tempString)!
        
        if cORf == 0 {
            tempF = (tempDouble * 9.0/5.0) + 32
        } else {
            tempF = tempDouble
        }
        print(tempF)
        
        return tempF
    }
    
}

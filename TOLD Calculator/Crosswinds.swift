//
//  Crosswinds.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/11/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation
class Crosswinds {
    
    //Inputs to find XWind and Headwind are RWY Designation (ie 31 means a 310 Heading), wind direction, and wind speed
    
    func getAngleOff (rWY:Double , windDir:Double) -> Double {
        var runwayAngle: Double = 0
        var angleOff: Double = 0
        runwayAngle = rWY * 10                                            //Converting RWY Des to RWY Hdg
        
        angleOff = runwayAngle - windDir
        
        return angleOff
    }
    
    
    func findXWind (angleOff:Double , windSpeed: Double) -> Double {
        
        var xWind: Double = 0.0
        
        xWind = windSpeed * sin(angleOff * (Double.pi/180))
        
        return xWind                                                       //Negative value = L Xwind
    }
    
    
    func findHeadWind (angleOff: Double , windSpeed:Double) -> Double {
        var headWind: Double = 0
        
        headWind = (windSpeed * cos(angleOff * (Double.pi/180)))
        
        return headWind                                                     //negative value = tailwind
    }

}

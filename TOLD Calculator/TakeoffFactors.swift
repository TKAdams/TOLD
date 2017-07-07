//
//  TakeoffFactors.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/2/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class TakeoffFactors {
    
    //TakeoffTable [[Int]] is an array identical to the IFG lookup table where:
    //Rows start from index 0 = 120F to 26 = -20F
    //Note that index 26 should be -15F but they skipped to -20F
    
    var takeoffTable: [[Int]] = []
    var takeoffFactor: Double = 0.0
    let tOFFilename: String = "TakeoffFactor2"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: tOFFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        takeoffTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    
    func findFirstTempIndex (tempF: Double) -> Int {
        var index: Int = 1
        let secondHighestTemp: Double = 110
        
        var topIndexTemp = secondHighestTemp
        
        while topIndexTemp > tempF {
            if (index < 26) {
                index += 1
            }
            topIndexTemp -= 5
            
        }
        return index
    }
    
    func findFirstAltitudeIndex (altitude: Double) -> Int {
        var index: Int = 1
        let secondLowestAltitude: Double = 500
        
        var leadIndexAlt = secondLowestAltitude
        
        while leadIndexAlt < altitude {
            if ((leadIndexAlt != 5500) || (index >= 13)) {
                index += 1
            }
            leadIndexAlt += 500
            
        }
        return index
    }
    
    func getTakeoffFactor (tempF: Double, altitude: Double) -> Double {
        var i: Int = 0
        var j: Int = 0
        var toFactor: Double = 0.0
        
        i = findFirstTempIndex(tempF: tempF)
        j = findFirstAltitudeIndex(altitude: altitude)
        
        //Lookup the four values from the takeoff factor charts
        let a = Double(takeoffTable[i][j])
        let b = Double(takeoffTable[i][j+1])
        let c = Double(takeoffTable[i+1][j])
        let d = Double(takeoffTable[i+1][j+1])
        
        //Interpolate vertically according to tempF (must account for table variation of temp) and will cap at table edges.
//        var x = 0.0 //interpolated tempF on left
//        var y = 0.0 //interpolated tempF on right
//        switch tempF {
//        case -10000 ..< -20:
//            x = b
//            y = d
//        case -20 ..< -10:
//            
//        case 120..<10000:
//            x = a
//            y = c
//        default:
//            print ("went way out of range")
//        }
//        
        return toFactor
    }
    
//    func interpolate (x: Double, tempGap: Double, y: Double, z: Double) -> Double {
//        var value: Double = 0.0
//        var percent: Double = 0.0
//        
//        percent =
//        value = percent*(y-z)+z
//        
//        return value
//    }

}

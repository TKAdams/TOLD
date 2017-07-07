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
    
    func findLowerTempIndex (tempF: Double) -> Int {
        var index: Int = 1
        while Double(takeoffTable[index][0]) > tempF {
            if (index < 27) {
                index += 1
            }
        }
        return index
    }
    
    func findUpperAltitudeIndex (altitude: Double) -> Int {
        var index: Int = 1
        
        while Double(takeoffTable[0][index]) < altitude {
            if (index < 13) {
                index += 1
            }
        }
        return index
    }
    
    func getTakeoffFactor (tempF: Double, altitude: Double) -> Double {
        //Updated
        var i: Int = 0
        var j: Int = 0
        var toFactor: Double = 0.0
        
        i = findLowerTempIndex(tempF: tempF)
        j = findUpperAltitudeIndex(altitude: altitude)
        
        //Lookup the four values from the takeoff factor charts

        let a = Double(takeoffTable[i-1][j-1])
        let b = Double(takeoffTable[i-1][j])
        let c = Double(takeoffTable[i][j-1])
        let d = Double(takeoffTable[i][j])

        print( String(a) + " , " + String(b) + "\n" + String(c) + " , " + String(d))
        
        let tHigh = Double(takeoffTable[i-1][0])
        let tLow = Double(takeoffTable[i][0])
        let aHigh = Double(takeoffTable[0][j])
        let aLow = Double(takeoffTable[0][j-1])
        
        let perDiffTemp = (tempF - tLow) / (tHigh - tLow)
        let perDiffAlt = (altitude - aLow) / (aHigh - aLow)
    
        print (String(perDiffTemp) + " , " + String(perDiffAlt))
        
        let tIntLow = (perDiffTemp * (a - c)) + c
        let tIntHigh = (perDiffTemp * (b - d)) + d
        
        toFactor = (perDiffAlt * (tIntHigh - tIntLow)) + tIntLow
        
        print("***TOF = " + String(toFactor))
        
        return toFactor
    }


}

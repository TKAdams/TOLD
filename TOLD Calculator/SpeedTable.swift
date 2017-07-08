//
//  SpeedTable.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 7/3/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class SpeedTable {
    
    //SpeedTable [[Int]] is an array identical to the IFG lookup table where:
    //Rows start from index 0 = 210 to 22 = 420
    //0:0=GWT 0:1=15&20 WS Rotate 0:2 15&20WS Takeoff 0:3=S/S Off Rotate 0:4=S/S Off Takeoff
    //Takeoff Speed is always Rotate Speed + 15kts and S/S Off numbers are +12  from 15&20 WS Numbers
    
    var speedChart: [[Int]] = []
    let tOSFilename: String = "Speedschart"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: tOSFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        speedChart = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        
    }
    
    func findGrossWeightIndex (grossWeight:Double) -> Int{
        var index: Int = 0
        var lowIndexGW:Double = 220
        
        while lowIndexGW < grossWeight {
            if ((index <= 21)){
                index += 1}
            lowIndexGW += 10
            }
        
        return index

    }
    
    func getRotateSpeed (wingsweep: Bool, grossWeight:Double) -> Double {
        var rotateSpeed: Double = 0
        var i: Int = 0
        var j: Int = 0
        var deltaGrossWeight: Double = 0 //using the deltas to calculate the knots per pound//
        var deltaSpeed: Double = 0
        var knotPerPound: Double = 0
    
        i = findGrossWeightIndex(grossWeight: grossWeight)
        j = i + 1
        
        let deltaGWAndBottomGW: Double = grossWeight - Double(speedChart[i][0])
        deltaGrossWeight = Double(speedChart[j][0]) - Double(speedChart[i][0])
        
        //deltaGrossWeight equals the higher chart gross weight minus the lower chart gross weight in the tables to find the difference in gross weight, this will equal 10. We will then find the delta speed and divide the deltaSpeed/deltaGrossWeight to find the knots per pound.//
        
        if wingsweep == true {
            deltaSpeed = ((Double(speedChart[j][1])) - (Double(speedChart[i][1]))) //finding chart deltaSpeed//
            knotPerPound=(deltaSpeed / deltaGrossWeight)
            rotateSpeed = Double(speedChart[i][1]) + (deltaGWAndBottomGW*knotPerPound)
            rotateSpeed = rotateSpeed.rounded(.up)
        }
        else {
            
            deltaSpeed = ((Double(speedChart[j][3])) - (Double(speedChart[i][3])))
            knotPerPound=(deltaSpeed / deltaGrossWeight)
            rotateSpeed = Double(speedChart[i][3]) + (deltaGWAndBottomGW*knotPerPound)
            rotateSpeed = rotateSpeed.rounded(.up)
        }
        print(rotateSpeed.rounded(.up))
    return rotateSpeed
    }
    //  Same concept as above, but for the T/O speed which is one index to the right of rotateSpeed
    
    func getTOSpeed (wingSweep:Bool, grossWeight:Double)-> Double{
        var tOSpeed: Double = 0
        var i: Int = 0
        var j: Int = 0
        var deltaGrossWeight: Double = 0 //using the deltas to calculate the knots per pound//
        var deltaSpeed: Double = 0
        var knotPerPound: Double = 0
        
        i = findGrossWeightIndex(grossWeight: Double(grossWeight))
        j = i + 1
        
        let deltaGWAndBottomGW: Double = (grossWeight - Double(speedChart[i][0]))
        deltaGrossWeight = Double(speedChart[j][0]) - Double(speedChart[i][0])
        
        //deltaGrossWeight equals the higher chart gross weight minus the lower chart gross weight in the tables to find the difference in gross weight, this will equal 10. We will then find the delta speed and divide the deltaSpeed/deltaGrossWeight to find the knots per pound.//
        
        if wingSweep == true {
            deltaSpeed = ((Double(speedChart[j][2])) - (Double(speedChart[i][2]))) //finding chart deltaSpeed//
            knotPerPound=(deltaSpeed / deltaGrossWeight)
            tOSpeed = Double(speedChart[i][2]) + (deltaGWAndBottomGW*knotPerPound)
            tOSpeed = tOSpeed.rounded(.up)
        }
        else {
            
            deltaSpeed = ((Double(speedChart[j][4])) - (Double(speedChart[i][4])))
            knotPerPound=(deltaSpeed / deltaGrossWeight)
            tOSpeed = Double(speedChart[i][4]) + (deltaGWAndBottomGW*knotPerPound)
            tOSpeed = tOSpeed.rounded(.up)
        }
        print(tOSpeed.rounded(.up))
        
    return tOSpeed

    }
}

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
        
        
        while lowIndexGW > grossWeight {
            if ((index >= 21)){
                index += 1}
            lowIndexGW += 10
            }
        return index
        }
        
        
        
        
        
        
    
        
    
}

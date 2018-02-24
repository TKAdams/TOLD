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
    var takeoffFactor: Double?
    let tOFFilename: String = "TakeoffFactor2"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: tOFFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        takeoffTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    
    func getTakeoffFactor (tempF: Double, altitude: Double) -> Double? {
        var toFactor: Double?
        
        toFactor = Math.interpolateTable(table: takeoffTable, rowValue: tempF, colValue: altitude)
        
        return toFactor
    }

}

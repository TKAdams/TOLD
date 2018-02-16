//
//  RefusalSpeed.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 7/29/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation
class RefusalSpeed{
    var refusalSpeedTable:[[Int]] = []
    var refusalSpeed: Double = 0
    let rSFilename: String = "RefusalSpeedChart"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: rSFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        refusalSpeedTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
		
    }
    
    func getRefusalSpeed(availableRunway: Double, refusalFactor:Double)->Double{
        var rS: Double = 0
        
        if let rs = Math.interpolateTable(table: refusalSpeedTable, rowValue: refusalFactor, colValue: availableRunway) {
            rS = rs
            print("if let refusal speed = \(rs)")
        } else {
            rS = 0
        }

        print("refusal speed = \(rS)")
        return rS
    }
	
}

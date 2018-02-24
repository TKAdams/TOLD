//
//  TwoEngineClimb.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 2/24/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation

class TwoEngineClimb{
    var uncorrectedTwoEngineClimbTable:[[Int]] = []
    var twoEngineClimbCorrectionTable:[[Int]] = []
    var twoEngineClimbCorrection: Double = 0
    let uncorrectedTwoEngineClimbFilename: String = "Climb2Engine"
    let twoEngineClimbCorrectionFilename: String = "twoEngineCorrection"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: twoEngineClimbCorrectionFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        var csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        twoEngineClimbCorrectionTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        data = CSVReader.readDataFromCSV(fileName: uncorrectedTwoEngineClimbFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        uncorrectedTwoEngineClimbTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    
    func getUncorrectedTwoEngineClimb (gwt: Double, tof: Double) -> Double? {
        var uncorrectedTwoEngineClimb: Double?
        
        uncorrectedTwoEngineClimb = Math.interpolateTable(table: uncorrectedTwoEngineClimbTable, rowValue: gwt, colValue: tof)
        return uncorrectedTwoEngineClimb
    }
    
    func getTwoEngineClimbCorrection (gwt: Double, temp: Double) -> Double? {
        var twoEngineClimbCorrection: Double?
        
        twoEngineClimbCorrection = Math.interpolateTable(table: twoEngineClimbCorrectionTable, rowValue: gwt, colValue: temp)
        return twoEngineClimbCorrection
    }
    
    func getCorrectedTwoEngineClimb (gwt: Double, tof: Double, temp: Double, wingSweep: WingSweep) -> Double? {
        var correctedTwoEngineClimb: Double?
        var uncorrectedTwoEngineClimb: Double?
        var twoEngineClimbCorrection: Double?
        
        uncorrectedTwoEngineClimb = getUncorrectedTwoEngineClimb(gwt: gwt, tof: tof)
        twoEngineClimbCorrection = getTwoEngineClimbCorrection(gwt: gwt, temp: temp)
        let baseClimb = uncorrectedTwoEngineClimb! + twoEngineClimbCorrection!
        
        switch wingSweep{
            
        case .WS15:
            correctedTwoEngineClimb = baseClimb
            
        case .WS20:
            if (twoEngineClimbCorrection! > 1500){
                correctedTwoEngineClimb = baseClimb + 25
            } else if (twoEngineClimbCorrection! < 500){
                correctedTwoEngineClimb = baseClimb - 25
            } else {
                correctedTwoEngineClimb = baseClimb
            }
            
        case .SSoff20:
            if (twoEngineClimbCorrection! > 1500){
                correctedTwoEngineClimb = baseClimb + 25
            } else if (twoEngineClimbCorrection! < 500){
                correctedTwoEngineClimb = baseClimb - 25
            } else {
                correctedTwoEngineClimb = baseClimb
            }
        }
        
        return correctedTwoEngineClimb
    }
}

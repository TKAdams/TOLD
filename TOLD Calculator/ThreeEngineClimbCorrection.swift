//
//  ThreeEngineClimbCorrection.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/11/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation
class ThreeEngineClimb2{
    var uncorrectedThreeEngineClimbTable:[[Int]] = []
    var threeEngineClimbCorrectionTable:[[Int]] = []
    var threeEngineClimbCorrection: Double = 0
    let uncorrectedThreeEngineClimbFilename: String = "Climb3Engine"
    let threeEngineClimbCorrectionFilename: String = "threeEngineCorrection"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: threeEngineClimbCorrectionFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        var csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        threeEngineClimbCorrectionTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        data = CSVReader.readDataFromCSV(fileName: uncorrectedThreeEngineClimbFilename, fileType: "csv")

        data = CSVReader.cleanRows(file: data!)
        csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        uncorrectedThreeEngineClimbTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)

    }
    
    func getUncorrectedThreeEngineClimb (gwt: Double, tof: Double) -> Double? {
        
        var uncorrectedThreeEngineClimb: Double?
        
        uncorrectedThreeEngineClimb = Math.interpolateTable(table: uncorrectedThreeEngineClimbTable, rowValue: gwt, colValue: tof)
        
        return uncorrectedThreeEngineClimb
    }
    
    func getThreeEngineClimbCorrection (gwt:Double , temp: Double) -> Double? {     //TODO: add 20WS
        
        var threeEngineClimbCorrection: Double?
        
        threeEngineClimbCorrection = Math.interpolateTable(table: threeEngineClimbCorrectionTable, rowValue: temp, colValue: gwt)

        return threeEngineClimbCorrection
    }
    
    func getCorrectedThreeEngineClimb (gwt: Double, tof: Double, temp: Double, wingSweep: WingSweep) -> Double? {
        var correctedThreeEngineClimb: Double?
        var uncorrectedThreeEngineClimb: Double?
        var threeEngineClimbCorrection: Double?
        
        uncorrectedThreeEngineClimb = getUncorrectedThreeEngineClimb(gwt: gwt, tof: tof)
        threeEngineClimbCorrection = getThreeEngineClimbCorrection(gwt: gwt, temp: temp)
        
        switch wingSweep{
            
        case .WS15:
            correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection!
            
        case .WS20:
            if (threeEngineClimbCorrection! > 1500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection! + 25
            } else if (threeEngineClimbCorrection! < 500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection! - 25
            } else {
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection!
            }
            
        case .SSoff20:
            if (threeEngineClimbCorrection! > 1500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection! + 25
            } else if (threeEngineClimbCorrection! < 500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection! - 25
            } else {
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection!
            }
        default:
            correctedThreeEngineClimb = uncorrectedThreeEngineClimb! + threeEngineClimbCorrection!
        }
        
        return correctedThreeEngineClimb
    }
    
}




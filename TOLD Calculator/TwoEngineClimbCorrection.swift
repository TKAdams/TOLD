//
//  TwoEngineClimbCorrection.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/10/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation
class TwoEngineClimbCorrection{
    var twoEngineClimbCorrectionTable:[[Int]] = []
    var twoEngineClimbCorrection:Double = 0
    let twoEngineClimbCorrectionFilename: String = "twoEngineCorrection"
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: twoEngineClimbCorrectionFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        twoEngineClimbCorrectionTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    /*
     Use this diagram for the interpolation calculation:
     colLow      colHigh
     rowLow      a           b
     |           |
     ac    -     x     -     bd
     |           |
     rowHigh     c           d
     */
    
    func getHighTempIndex (temp:Double) -> Int {
        var index: Int = 0
        
        while (Double(twoEngineClimbCorrectionTable[index][0]) < temp) {
            if (index < 9){
                index += 1
            }
        }
        
        return index
    }
    
    func getHighGWTIndex (gwt:Double) -> Int {
        var index: Int = 0
        
        while (Double(twoEngineClimbCorrectionTable[0][index]) < gwt) {
            if (index < 5){
                index += 1
            }
        }
        
        return index
    }
    
    func getTwoEngineClimbCorrection (gwt:Double , temp: Double) -> Double {     //TODO: add 20WS 
        
        var i = 0
        var j = 0
        var twoEngineClimbCorrection: Double = 0
        
        i = getHighTempIndex(temp: temp)    //Rows
        j = getHighGWTIndex(gwt: gwt)       //Cols
        
        let a = Double(twoEngineClimbCorrectionTable[i-1][j-1])  //Low GWT low temp
        let b = Double(twoEngineClimbCorrectionTable[i-1][j])    //low GWT high temp
        let c = Double(twoEngineClimbCorrectionTable[i][j-1])    //high GWT low temp
        let d = Double(twoEngineClimbCorrectionTable[i][j])      //high GWT high temp
        
        let highGWT = Double(twoEngineClimbCorrectionTable[0][j])
        let lowGWT = Double(twoEngineClimbCorrectionTable[0][j-1])
        let highTemp = Double(twoEngineClimbCorrectionTable[i][0])
        let lowTemp = Double(twoEngineClimbCorrectionTable[i-1][0])
        
        let perDiffTemp = (temp - lowTemp)/(highTemp-lowTemp)
        let perDiffGWT = (gwt - highGWT)/(highGWT-lowGWT)
        
        let ac = (perDiffGWT * (c - a)) + a
        let bd = (perDiffGWT * (b - d)) + d
        
        twoEngineClimbCorrection = (perDiffTemp * (bd - ac)) + ac
        
        return twoEngineClimbCorrection
    }
}
    



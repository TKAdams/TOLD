//
//  ThreeEngineClimbCorrection.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/11/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation
class ThreeEngineClimbCorrection{
    var threeEngineClimbCorrectionTable:[[Int]] = []
    var threeEngineClimbCorrection:Double = 0
    let threeEngineClimbCorrectionFilename: String = "threeEngineCorrection"
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: threeEngineClimbCorrectionFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        threeEngineClimbCorrectionTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    
    func getHighTempIndex (temp:Double) -> Int {
        var index: Int = 0
        
        while (Double(threeEngineClimbCorrectionTable[index][0]) < temp) {
            if (index < 9){
                index += 1
            }
        }
        
        return index
    }
    
    func getHighGWTIndex (gwt:Double) -> Int {
        var index: Int = 0
        
        while (Double(threeEngineClimbCorrectionTable[0][index]) < gwt) {
            if (index < 5){
                index += 1
            }
        }
        
        return index
    }
    
    func getThreeEngineClimbCorrection (gwt:Double , temp: Double) -> Double {     //TODO: add 20WS
        
        var i = 0
        var j = 0
        var threeEngineClimbCorrection: Double = 0
        
        i = getHighTempIndex(temp: temp)    //Rows
        j = getHighGWTIndex(gwt: gwt)       //Cols
        
        let a = Double(threeEngineClimbCorrectionTable[i-1][j-1])  //Low GWT low temp
        let b = Double(threeEngineClimbCorrectionTable[i-1][j])    //low GWT high temp
        let c = Double(threeEngineClimbCorrectionTable[i][j-1])    //high GWT low temp
        let d = Double(threeEngineClimbCorrectionTable[i][j])      //high GWT high temp
        
        let highGWT = Double(threeEngineClimbCorrectionTable[0][j])
        let lowGWT = Double(threeEngineClimbCorrectionTable[0][j-1])
        let highTemp = Double(threeEngineClimbCorrectionTable[i][0])
        let lowTemp = Double(threeEngineClimbCorrectionTable[i-1][0])
        
        let perDiffTemp = (temp - lowTemp)/(highTemp-lowTemp)
        let perDiffGWT = (gwt - highGWT)/(highGWT-lowGWT)
        
        let ac = (perDiffGWT * (c - a)) + a
        let bd = (perDiffGWT * (b - d)) + d
        
        threeEngineClimbCorrection = (perDiffTemp * (bd - ac)) + ac
        
        return threeEngineClimbCorrection
    }
    
}




//
//  RSCorrection.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 7/30/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation
class RSCorrection{
    var rSCorrectionTable:[[Int]] = []
    var rSCorrection:Double = 0
    let rSCorrectionFilename: String = "RSCorrectionChart"
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: rSCorrectionFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        rSCorrectionTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        
    }
    
    func getHighRS(refusalSpeed:Double) -> Int{
        var index = 0
        while Double(rSCorrectionTable[0][index]) < refusalSpeed{
            if (index < 22){
                index += 1
            }
        }
        return index
    }
    
    func updateRS(refusalSpeed:Double, rCR: Int) -> Double {
        let j = getHighRS(refusalSpeed: refusalSpeed)
        var i = 0
        
        switch rCR{
        case 0:
            i = 2
            let diffRS = (refusalSpeed-Double(rSCorrectionTable[0][j-1]))/(Double(rSCorrectionTable[0][j])-Double(rSCorrectionTable[0][j-1]))
            rSCorrection = diffRS * (Double(rSCorrectionTable[i][j])-Double(rSCorrectionTable[i][j-1])) + Double(rSCorrectionTable[i][j-1])
            print("9 RCR REfusal Speed is \(rSCorrection)")
        
        case 1:
            i = 1
            let diffRS = (refusalSpeed-Double(rSCorrectionTable[0][j-1]))/(Double(rSCorrectionTable[0][j])-Double(rSCorrectionTable[0][j-1]))
            rSCorrection = diffRS * (Double(rSCorrectionTable[i][j])-Double(rSCorrectionTable[i][j-1])) + Double(rSCorrectionTable[i][j-1])
            print("12 RCR Refusal speed is \(rSCorrection)")
            
        case 2:
            rSCorrection = refusalSpeed


        default:
            rSCorrection = refusalSpeed
        }
        print("RS Correction is \(rSCorrection)")
        return rSCorrection
    }
}

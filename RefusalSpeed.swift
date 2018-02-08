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
    var refusalSpeed:Double = 0
    let rSFilename: String = "RefusalSpeedChart"
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: rSFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        refusalSpeedTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        
    }
	
    func getHighRW (availableRunway: Double)-> Int{
        var index = 1
        while Double(refusalSpeedTable[0][index]) < availableRunway {
            if(index < 14){
                index+=1
            }
        }
//      print("high takeoff distance  is \(refusalSpeedTable[0][index])")
        return index
    }
    
    func getHighRF (refusalFactor:Double) -> Int{
        var index = 1
        while Double(refusalSpeedTable[index][0]) < refusalFactor {
            if index < 22 {
                index += 1
            }
        }
//        print("high RF index is \(index)")
        return index
    }
    
    func getRefusalSpeed(availableRunway: Double, refusalFactor:Double)->Double{
        var i:Int = 0
        var j:Int = 0
        var refusalSpeed:Double = 0.0
        
        i=getHighRF(refusalFactor: refusalFactor)
        j=getHighRW(availableRunway: availableRunway)
       
        if (i >= 1 && i < 15) && (j >= 1 && j < 23) {
            let a = Double(refusalSpeedTable[i-1][j-1]) //Low GW and Low TOF
            let b = Double(refusalSpeedTable[i-1][j])   //Low GW and High TOF
            let c = Double(refusalSpeedTable[i][j-1])   //High GW and Low TOF
            let d = Double(refusalSpeedTable[i][j])     //Low GW and Low TOF
        
        print ("a=\(a) b=\(b) c=\(c) d=\(d)")
        
            let rSFHigh = Double(refusalSpeedTable[i][0])     //High GW
            let rSFLow = Double(refusalSpeedTable[i-1][0])    //Low GW
            let rWHigh = Double(refusalSpeedTable[0][j])    //High TOF
            let rWLow = Double(refusalSpeedTable[0][j-1])   //Low TOF
        
        print("rWHigh = \(rWHigh) rWLow = \(rWLow) rsFHigh = \(rSFHigh) rsFLow = \(rSFLow)")
        

        let perDiffRW = ((availableRunway-rWLow)/(rWHigh-rWLow))     //The percent diff for RW
        let perDiffRSF = ((refusalFactor-rSFLow)/(rSFHigh-rSFLow)) //The percent diff for RSF
        
//        print("perDiffRW = \(perDiffGW) perDiffTOF = \(perDiffTOF)")
        
//        let rWIntLow = (perDiffRSF * (a - b)) + b
//        let rWIntHigh = (perDiffRSF * (c - d)) + d
//
//        refusalSpeed = (perDiffRW * (rWIntHigh - rWIntLow)) + rWIntLow
        
        let ac = (perDiffRSF * (c - a)) + a
        let bd = (perDiffRSF * (d - b)) + b
        
        refusalSpeed = (perDiffRW * (bd - ac)) + ac
        
        print("refusal Speed is \(refusalSpeed)")
        
            refusalSpeed = (perDiffRW * (rWIntHigh - rWIntLow)) + rWIntLow
        
            print("refusal Speed is \(refusalSpeed)")
        }
        else {
            refusalSpeed = 0
        }
            
            return refusalSpeed
    }
    
    //    func getRefusalSpeed (gWT:Double, fieldLength: Double)->Double{
}

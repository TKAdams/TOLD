//
//  RefusalFactor.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 7/19/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class RefusalFactor{
    var refusalFactorTable:[[Int]] = []
    var refusalFactor:Double = 0
    let rFFilename: String = "RefusalFactorChart"
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: rFFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        refusalFactorTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
	
	// TODO: Review this function
    func getHighTOF (tOF:Double)-> Int{
        var index=0
        while Double(refusalFactorTable[0][index]) < tOF{
            if(index < 15){
                index+=1
            }
        }
        print("low rF is \(index)")
        return index
    }
    
    func getHighGW (gWt:Double) -> Int{
       var index = 1
        while Double(refusalFactorTable[index][0]) < gWt {
            if index < 22 {
                index += 1
            }
        }
        print("lowGW is \(index)")
        return index
    }
    
    func getRefusalFactor(gWt: Double, tOF:Double)->Double{
        var i:Int = 0
        var j:Int = 0
        var refusalFactor:Double = 0.0
        
        i=getHighGW(gWt: gWt)
        j=getHighTOF(tOF: tOF)
        
        let a = Double(refusalFactorTable[i-1][j-1]) //Low GW and Low TOF
        let b = Double(refusalFactorTable[i-1][j])   //Low GW and High TOF
        let c = Double(refusalFactorTable[i][j-1])   //High GW and Low TOF
        let d = Double(refusalFactorTable[i][j])     //Low GW and Low TOF
        
//        print ("a=\(a) b=\(b) c=\(c) d=\(d)")
        
        let gWHigh = Double(refusalFactorTable[i][0])     //High GW
        let gWLow = Double(refusalFactorTable[i-1][0])    //Low GW
        let tOFHigh = Double(refusalFactorTable[0][j])    //High TOF
        let tOFLow = Double(refusalFactorTable[0][j-1])   //Low TOF
        
//        print("gWHigh = \(gWHigh) gWLow = \(gWLow) tOFHigh = \(tOFHigh) tOFLow = \(tOFLow)")
        
        let perDiffGW = ((gWt-gWLow)/(gWHigh-gWLow))     //The percent diff for GW
        let perDiffTOF = ((tOF-tOFLow)/(tOFHigh-tOFLow)) //The percent diff for TOF
        
//        print("perDiffGW = \(perDiffGW) perDiffTOF = \(perDiffTOF)")
        
        let gWIntLow = (perDiffTOF * (a - b)) + b
        let gWIntHigh = (perDiffTOF * (c - d)) + d
        
        refusalFactor = (perDiffGW * (gWIntHigh - gWIntLow)) + gWIntLow
        
        print("refusal factor is \(refusalFactor)")
        
        return refusalFactor
        
    }
    
//    func getRefusalSpeed (gWT:Double, fieldLength: Double)->Double{
        
//    }
}

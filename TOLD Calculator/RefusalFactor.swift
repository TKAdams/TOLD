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
        var index = 1
        while Double(refusalFactorTable[0][index]) < tOF{
            if(index < 15){
                index+=1
            }
        }
        print("High TOF index \(index). High TOF \(refusalFactorTable[0][index])")
        return index
    }
    
    func getHighGW (gWt:Double) -> Int{
       var index = 1
        while Double(refusalFactorTable[index][0]) < gWt {
            if index < 22 {
                index += 1
            }
        }
        print("High GW index \(index). High TOF \(refusalFactorTable[index][0])")
        return index
    }
    
    func getRefusalFactor(gWt: Double, tOF:Double)->Double{
        var i:Int = 0
        var j:Int = 0
        var refusalFactor:Double = 0.0
        
        i=getHighGW(gWt: gWt) //Rows
        j=getHighTOF(tOF: tOF) //Columns
		
		Math.interpolateTable(table: refusalFactorTable, rowValue: gWt, colValue: tOF)
		
        /*
         Use this diagram for the interpolation calculation:
                    colLow      colHigh
        rowLow      a           b
                    |           |
                    ac -    x - bd
                    |           |
        rowHigh     c           d
         */
        
        let a = Double(refusalFactorTable[i-1][j-1]) //Low GW and Low TOF
        let b = Double(refusalFactorTable[i-1][j])   //Low GW and High TOF
        let c = Double(refusalFactorTable[i][j-1])   //High GW and Low TOF
        let d = Double(refusalFactorTable[i][j])     //Low GW and Low TOF
        
        print ("a=\(a) b=\(b) c=\(c) d=\(d)")
        
        let gWHigh = Double(refusalFactorTable[i][0])     //High GW
        let gWLow = Double(refusalFactorTable[i-1][0])    //Low GW
        let tOFHigh = Double(refusalFactorTable[0][j])    //High TOF
        let tOFLow = Double(refusalFactorTable[0][j-1])   //Low TOF
        
        print("gWHigh = \(gWHigh) gWLow = \(gWLow) tOFHigh = \(tOFHigh) tOFLow = \(tOFLow)")
        
        let perDiffGW = ((gWt-gWLow)/(gWHigh-gWLow))     //The percent diff for GW
        let perDiffTOF = ((tOF-tOFLow)/(tOFHigh-tOFLow)) //The percent diff for TOF
        
        print("perDiffGW = \(perDiffGW) perDiffTOF = \(perDiffTOF)")
        
        let ac = (perDiffGW * (c - a)) + a
        let bd = (perDiffGW * (d - b)) + b
        
        refusalFactor = (perDiffTOF * (bd - ac)) + ac
        
        print("refusal factor is \(refusalFactor)")
        
        return refusalFactor
        
    }
    
}

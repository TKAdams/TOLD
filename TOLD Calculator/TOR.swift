//
//  TOR.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/21/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation

class TOR{
    
    var tORNormTable: [[Int]] = []
    var tORSSoff20Table: [[Int]] = []
    let tORFilename = "TOR Norm"
    let tORSSoff20Filename = "TORSSoff20"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: tORFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        
        var csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        
        tORNormTable = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        data = CSVReader.readDataFromCSV(fileName: tORSSoff20Filename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        tORSSoff20Table = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
    }
    
    func getTORNorm (tOF: Double, gwt: Double) -> Double? {
        
        var tORNorm: Double?
        
        tORNorm = Math.interpolateTable(table: tORNormTable, rowValue: gwt, colValue: tOF)
        
        return tORNorm
    }
    
    func getTORSSoff20 (tOF: Double, gwt: Double) -> Double? {
        
        var tORSSoff20: Double?
        
        tORSSoff20 = Math.interpolateTable(table: tORSSoff20Table, rowValue: gwt, colValue: tOF)
        
        return tORSSoff20
    }
    
    func getTOR (tOF:Double, gwt: Double, wingSweep:WingSweep) -> Double?{
        
        var tOR: Double?
        
        switch wingSweep{
        case .WS15:
            tOR = getTORNorm(tOF: tOF, gwt: gwt)
        case .WS20:
            tOR = getTORNorm(tOF: tOF, gwt: gwt)
        case .SSoff20:
            tOR = getTORSSoff20(tOF: tOF, gwt: gwt)              //enum is exhaustive no need for default
        }
        
        return tOR
    }
    
}

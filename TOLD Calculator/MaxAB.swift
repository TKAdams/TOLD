//
//  MaxAB.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/15/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class MaxAB {
    
//    This class represents the maxAB tables in the IFG - Currently 15 AUGUST 2016
//    It consists of a three dimensional array of integers.
//    The FIRST index represents a particular GWT and holds an array of arrays that is the maxab table.
//        index 0 = GWT 210
//        index 21 = GWT 420
//    The SECOND index represents a particular takeoff factor and holds an array of values of the row.
//        index 0 = tof 20
//        index 8 = tof 60
//    The THIRD index represents a particular lookup value
//        index 0 = TOR Norm
//        index 1 = TOR 20 WS S/S OFF
//        index 2 = Climb 3 engines
//        index 3 = Climb 2 engines
//        index 4 = Brake CAUTION
//        index 5 = Brake DANGER
//        index 6 = CFL dry (26) NORM
//        index 7 = CFL dry (26) 20 WS S/S OFF
//        index 8 = CFL wet (12) NORM
//        index 9 = CFL wet (12) 20 WS S/S OFF
//        index 10 = CFL icy (9) NORM
//    Special int values will represent nonintegar values on the chart
//        10001 = N/A
//        10002 = No Data
//        10003 = ----
    
    var maxAB: [[[Int]]] = []
    let tOSFilename: String = "maxab"
    
    init () {
        
        var data = CSVReader.readDataFromCSV(fileName: tOSFilename, fileType: "csv")
        
        data = CSVReader.cleanRows(file: data!)
        let csvStringRows = CSVReader.convertCSVDataToStringArray(data: data!)
        maxAB = convertMaxABStringArraytoIntArray(stringData: csvStringRows)
        
        
    }
    
    func convertMaxABStringArraytoIntArray (stringData: [[String]]) -> [[[Int]]] {
        
        let tables: Int = 22
        let rowsTOFs: Int = 9
        let colsValues: Int =  11

        var intArray: [[[Int]]] = Array(repeating: Array(repeating: Array (repeating: 0, count: colsValues), count: rowsTOFs), count: tables)
        
        for table in 0...(tables-1) {
            for rowTOF in 0...(rowsTOFs-1) {
                for colsValues in 0...(colsValues-1) {

                    var stringDataRow: Int = table * 9 + rowTOF
                    var tempString = stringData[stringDataRow][colsValues + 2]
                    
                    tempString = tempString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                    
                    switch tempString{
                    case "N/A":
                        intArray[table][rowTOF][colsValues] = 10001
                    case "NO":
                        intArray[table][rowTOF][colsValues] = 10002
                    case "DATA":
                        intArray[table][rowTOF][colsValues] = 10002
                    case "----":
                        intArray[table][rowTOF][colsValues] = 10003
                    default:
                        intArray[table][rowTOF][colsValues] = Int(tempString)!
                    }
                }
            }
        }

        return intArray
    }
}

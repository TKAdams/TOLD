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
//    It consists of a triple array of integers.
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
//        index 4 = Break CAUTION
//        index 5 = Break DANGER
//        index 6 = CFL dry NORM
//        index 7 = CFL dry 20 WS S/S OFF
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
        //maxAB = CSVReader.convertStringArrayToIntArray(stringData: csvStringRows)
        
        
    }
}

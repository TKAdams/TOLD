//
//  CSVReader.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/3/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class CSVReader {

    class func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }

    class func convertCSVDataToStringArray(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }

    class func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    class func convertStringArrayToIntArray(stringData: [[String]]) -> [[Int]] {

        let rows: Int = stringData.count
        let cols: Int = stringData[0].count
        
        var intArray: [[Int]] = Array(repeating: Array(repeating: 0, count: cols), count: rows)
        
        for row in 0...(rows-1) {
            for col in 0...(cols-1) {
                var tempString = stringData[row][col]
                tempString = tempString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                intArray[row][col] = Int(tempString)!
            }
        }
        
        return intArray
    }
}

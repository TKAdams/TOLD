//
//  Math.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 2/11/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import Foundation

class Math {

	//The following class looks up and interpolates points on a table.
	//The return value is an optional and will return nil IF a value passed is off the table.
	class func interpolateTable(table: [[Int]], rowValue: Double, colValue:Double) -> Double? {

		var value: Double? = 0.0
		
		let numCols = table[0].count
		let numRows = table.count
		let colValueLowest = table[0][1]
		let colValueHighest = table[0][numCols-1]
		let rowValueLowest = table[1][0]
		let rowValueHighest = table[numRows-1][0]
		
		var oob: Bool = false  //Out of bounds. Or off the chart.
		
		var i: Int = 0 //col index
		var j: Int = 0 //row index
		
		/*
		Use this diagram for the interpolation calculation:
				colLow      colHigh
		rowLow      a           b
					|           |
					ac -    x - bd
					|           |
		rowHigh     c           d
		*/
		
		//1. Determine if it is out of bounds.
		if (rowValue < Double(rowValueLowest)) ||
			(rowValue > Double(rowValueHighest)) ||
			(colValue < Double(colValueLowest)) ||
			(colValue > Double(colValueHighest)) {
			oob = true
			return nil
		}
		
		//2. Find the index for d as a column. (i)
		while Double(table[0][i]) < colValue{
			if(i < (numCols - 1)){
				i += 1
			}
		}
		
		//3. Find the index for d as a row. (j)
		while Double(table[j][0]) < rowValue {
			if j < (numRows - 1) {
				j += 1
			}
		}
		//4. Get values of headers
		let colLow = Double(table[0][i-1])
		let colHigh = Double(table[0][i])
		let rowLow = Double(table[j-1][0])
		let rowHigh = Double(table[j][0])
		
		//5. Get values a-d
		let a = Double(table[j-1][i-1])
		let b = Double(table[j-1][i])
		let c = Double(table[j][i-1])
		let d = Double(table[j][i])
		
		//6. Calculate ac and bd
		let perDiffRow = ((rowValue-rowLow)/(rowHigh-rowLow))
		let ac = (perDiffRow * (c - a)) + a
		let bd = (perDiffRow * (d - b)) + b

		//7. Calculate x
		let perDiffCol = ((colValue-colLow)/(colHigh-colLow))
		value = (perDiffCol * (bd - ac)) + ac
		
		return value
	}
}

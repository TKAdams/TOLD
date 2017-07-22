//
//  Flight.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/2/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

class Flight {
    
    var tOFTable: TakeoffFactors = TakeoffFactors()
    var speedTable: SpeedTable = SpeedTable()
    var maxAB: MaxAB = MaxAB()
    var rSF: RefusalFactor = RefusalFactor()
    
    var grossWeight: Double = 0.0 {
        didSet {
            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
        }
    }
    var wingSweep: Bool = true //wing sweep true = 15 WS or 20 WS
                                //wing sweep false = 20 WS SEF/SIS OFF
    var fieldLength: Double = 0.0
    
    var pressureAltitude: Double = 0.0 {
        didSet {
            tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
        }
    }
    var temperature: Double = 0.0  { //temperature in ºF
        didSet {
            tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
        }
    }
    var rCR: Double = 0.0
    
    var tOF: Double = 0.0 {
        didSet {
            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
//            Test:Remove when code implemented
//              rSF.getLowTOF(tOF: tOF)
//              rSF.getLowGW(gWt:grossWeight)
//              rSF.getRefusalSpeed(gWt: grossWeight, tOF: tOF)
        }
    }

    
    var refusalSpeedFactor: Double = 0.0
    var refusalSpeed: Double = 0.0
    var decisionSpeed: Double = 0.0
    var rotateSpeed: Double = 0.0
    var takeoffSpeed: Double = 0.0
    var twoEngineClimb: Double = 0.0
    var threeEngineClimb: Double = 0.0
    var brakeCaution: Double = 0.0
    var brakeDanger: Double = 0.0
    var takeOffDistance: Double = 0.0
    var cFL: Double = 0.0
    
    func setTemperature (temp: String, cORf: Int) -> Double {

        var tempF: Double = 0.0
        var tempString = temp
        var tempDouble: Double = 0.0
        
        tempString = tempString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        tempDouble = Double(tempString)!
        
        if cORf == 0 {
            tempF = (tempDouble * 9.0/5.0) + 32
        } else {
            tempF = tempDouble
        }
        print(tempF)
        
        return tempF
    }
    
    func updateTOFDependants (tof: Double, gwt: Double, wingSweep: Bool, rcr: Double) {
        var i: Int = 0  //gwt index
        var j: Int = 0  //tof index
        
        i = findUpperGWTIndex(gwt: gwt)
        j = findUpperTOFIndex(tof: tof)
        
        //Calculate Percent deltas
        
        var perDeltaGWT: Double = percentDeltaGWT(gwt: gwt)
        var perDeltaTOF: Double = percentDeltaTOF(tof: tof)
        
        threeEngineClimb = threeEngineClimb(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        twoEngineClimb = twoEngineClimb(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        brakeCaution = brakeCaution(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        brakeDanger = brakeDanger(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        
    }
    
    func findUpperGWTIndex (gwt: Double) -> Int {
        var index: Int = 1
        var gwtTable: Double = 220.0
        
        while gwtTable < gwt {
            if (index < 21) {
                index += 1
            }
            gwtTable += 10
        }
        return index
    }
    
    func findUpperTOFIndex (tof: Double) -> Int {
        var index: Int = 1
        var tofTable: Double = 25
        
        while tofTable < tof {
            if (index < 8) {
                index += 1
            }
            tofTable += 5
        }
        return index
    }
    
    func percentDeltaGWT (gwt: Double) -> Double {
        var gwtTable: Double = 210.0
        var percentDiff: Double = 0.0
        
        while gwtTable < gwt {
            gwtTable += 10
        }
        gwtTable -= 10
        if gwt < 210 {
            percentDiff = 0.0
        } else {
            percentDiff = (gwt - gwtTable)/10
        }
        
        return percentDiff
    }
    
    func percentDeltaTOF (tof: Double) -> Double {
        var tofTable: Double = 20.0
        var percentDiff: Double = 0.0
        
        while tofTable < tof {
            tofTable += 5
        }
        tofTable -= 5
        if tof < 20 {
            percentDiff = 0.0
        } else {
            percentDiff = (tof - tofTable)/5
        }
        
        return percentDiff
    }

    func twoEngineClimb (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double) -> Double {
        var threeEngineClimb: Double = 0.0
        let OutputIndex: Int = TOLDOutput.Climb2Engines.rawValue
        
        twoEngineClimb = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        return twoEngineClimb
    }
    
    func threeEngineClimb (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double) -> Double {
        var threeEngineClimb: Double = 0.0
        let OutputIndex: Int = TOLDOutput.Climb3Engines.rawValue
        
        threeEngineClimb = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        return threeEngineClimb
    }
    
    func brakeCaution (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double) -> Double {
        var brakeCaution: Double = 0.0
        let OutputIndex: Int = TOLDOutput.BrakeCaution.rawValue
        
        brakeCaution = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        return brakeCaution
    }
    
    func brakeDanger (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double) -> Double {
        var brakeDanger: Double = 0.0
        let OutputIndex: Int = TOLDOutput.BrakeDanger.rawValue
        
        brakeDanger = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        return brakeDanger
    }
    
    func interpolateIFG (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, outputIndex: Int) -> Double {
        let gi: Int = gwtUpperIndex - 1
        let gj: Int = gwtUpperIndex
        let ti: Int = TOFUpperIndex - 1
        let tj: Int = TOFUpperIndex
        let z: Int = outputIndex
        
        var a: Double = 0.0
        var b: Double = 0.0
        var c: Double = 0.0
        var d: Double = 0.0
        
        var ac: Double = 0.0
        var bd: Double = 0.0
        var value: Double = 0.0
        
        a = Double(maxAB.maxAB[gi][ti][z])
        b = Double(maxAB.maxAB[gi][tj][z])
        c = Double(maxAB.maxAB[gj][ti][z])
        d = Double(maxAB.maxAB[gj][tj][z])
        
        ac = (c - a) * deltaGWT + a
        bd = (d - b) * deltaGWT + b
        
        value = (bd - ac) * deltaTOF + ac
        
        return value
    }
    
}

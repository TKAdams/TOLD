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
    var rS: RefusalSpeed = RefusalSpeed()
    var rSCorr: RSCorrection = RSCorrection()
    
    var grossWeight: Double = 0.0
//	{
//        didSet {
//            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
//            takeoffSpeed = speedTable.getTOSpeed(wingSweep: wingSweep, grossWeight: grossWeight)
//            rotateSpeed = speedTable.getRotateSpeed(wingsweep: wingSweep, grossWeight: grossWeight)
//            decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
//        }
//    }
    var wingSweep: Bool = true //wing sweep true = 15 WS or 20 WS, wing sweep false = 20 WS SEF/SIS OFF
//	{
//        didSet{
//            takeoffSpeed = speedTable.getTOSpeed(wingSweep: wingSweep, grossWeight: grossWeight)
//            rotateSpeed = speedTable.getRotateSpeed(wingsweep: wingSweep, grossWeight: grossWeight)
//            decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
//            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
//        }
//    }
    var fieldLength: Double = 0.0
    
    var pressureAltitude: Double = 0.0
//	{
//        didSet {
//            tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
//        }
//    }
    var temperature: Double = 0.0 //temperature in ºF
//	{
//        didSet {
//            tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
//        }
//    }

    
    var tOF: Double = 0.0 {
        didSet {
            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
//            Test:Remove when code implemented
//              rS.getLowTOF(tOF: tOF)
//              rS.getLowGW(gWt:grossWeight)
            refusalSpeedFactor = rSF.getRefusalFactor(gWt: grossWeight, tOF: tOF)
            if takeOffDistance > 8000{
                refusalSpeed = rS.getRefusalSpeed(takeOffDistance: takeOffDistance, refusalFactor: refusalSpeedFactor)
                decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
            } //What is the best way to do this? It will fail if the tOF updates and takeoff Length is
              //not set yet. So I made the if statement to be the lowest takeoff distance.//
            
        }
    }
    

    var unCorrRefusalSpeed: Double = 0.0
    var refusalSpeed: Double = 0.0
    var decisionSpeed: Double = 0.0
    var rotateSpeed: Double = 0.0
    var takeoffSpeed: Double = 0.0
    var twoEngineClimb: Double = 0.0
    var threeEngineClimb: Double = 0.0
    var brakeCaution: Double = 0.0
    var brakeDanger: Double = 0.0
    var cFL: Double = 0.0
    var refusalSpeedFactor: Double = 0.0
    var tOR: Double = 0.0
    
    var takeOffDistance: Double = 0.0
//	{
//        didSet{
//            unCorrRefusalSpeed = rS.getRefusalSpeed(takeOffDistance: takeOffDistance, refusalFactor: refusalSpeedFactor)
//            refusalSpeed = rSCorr.updateRS(refusalSpeed: unCorrRefusalSpeed, rCR: rCR)
//            decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
//        }
//    }
	
    var rCR: Int = 2
//	{
//        didSet{
//            if takeOffDistance > 8000{                                            //Best Way?
//            refusalSpeed = rSCorr.updateRS(refusalSpeed: unCorrRefusalSpeed, rCR: rCR)
//            decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
//            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
//            }
//        }
//    }
	
	func process() {
		//only conduct the processing if inputs are within the table limits.
		//This should never be triggered unless everything is validated, but will double check.
		if grossWeight >= 210 && grossWeight <= 420 &&
			temperature  >= -20 && temperature <= 120 &&
			pressureAltitude >= 0 && pressureAltitude <= 6000 &&
			fieldLength >= 8000 && fieldLength <= 13500 {
			
			tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
			updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR)
			takeoffSpeed = speedTable.getTOSpeed(wingSweep: wingSweep, grossWeight: grossWeight)
			rotateSpeed = speedTable.getRotateSpeed(wingsweep: wingSweep, grossWeight: grossWeight)
			decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
			refusalSpeedFactor = rSF.getRefusalFactor(gWt: grossWeight, tOF: tOF)
			refusalSpeed = rS.getRefusalSpeed(takeOffDistance: takeOffDistance, refusalFactor: refusalSpeedFactor)
			decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
			unCorrRefusalSpeed = rS.getRefusalSpeed(takeOffDistance: takeOffDistance, refusalFactor: refusalSpeedFactor)
			
		}
		
	}
    
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
    
    func updateTOFDependants (tof: Double, gwt: Double, wingSweep: Bool, rcr: Int) {
        var i: Int = 0  //gwt index
        var j: Int = 0  //tof index
        
        i = findUpperGWTIndex(gwt: gwt)
        j = findUpperTOFIndex(tof: tof)
        
        //Calculate Percent deltas
        
        let perDeltaGWT: Double = percentDeltaGWT(gwt: gwt)
        let perDeltaTOF: Double = percentDeltaTOF(tof: tof)
        
        threeEngineClimb = threeEngineClimb(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        twoEngineClimb = twoEngineClimb(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        brakeCaution = brakeCaution(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        brakeDanger = brakeDanger(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF)
        cFL = cfl(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF, rcr: rCR, wingsweep: wingSweep)
        tOR = getTOR(gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF, wingSweep: wingSweep)
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
    
    func cfl (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, rcr: Int, wingsweep: Bool) -> Double {
        var cfl: Double = 0.0
        var OutputIndex: Int = 0
        
        switch rcr {
        case 0:
            OutputIndex = TOLDOutput.CFLIcyNorm.rawValue
        case 1:
            if wingsweep == true {
                OutputIndex = TOLDOutput.CFLWetNorm.rawValue
            } else {
                OutputIndex = TOLDOutput.CFLWetOff.rawValue
            }
        case 2:
            if wingsweep == true {
                OutputIndex = TOLDOutput.CFLDryNorm.rawValue
            } else {
                OutputIndex = TOLDOutput.CFLDryOff.rawValue
            }
        default:
            OutputIndex = TOLDOutput.CFLDryNorm.rawValue
        }
        
        cfl = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)

        return cfl
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
        
        var outOfBounds = false
        
        a = Double(maxAB.maxAB[gi][ti][z])
        b = Double(maxAB.maxAB[gi][tj][z])
        c = Double(maxAB.maxAB[gj][ti][z])
        d = Double(maxAB.maxAB[gj][tj][z])
        
        outOfBounds = checkBounds(a: a, b: b, c: c, d: d)
        
        if outOfBounds == true {
            value = setOutOfBoundsTag(a: a, b: b, c: c, d: d)
        } else {
            ac = (c - a) * deltaGWT + a
            bd = (d - b) * deltaGWT + b
        
            value = (bd - ac) * deltaTOF + ac
        }
            
        return value
    }
    
    func checkBounds (a: Double, b: Double, c: Double, d: Double) -> Bool {
        var oob = false
        
        if a > 100000 {
            oob = true
        }
        if b > 100000 {
            oob = true
        }
        if c > 100000 {
            oob = true
        }
        if d > 100000 {
            oob = true
        }
        
        return oob
    }
    
    func setOutOfBoundsTag (a: Double, b: Double, c: Double, d: Double) -> Double {
        var value = 0.0
        
        //Return the highest value.
        if a > value {
            value = a
        }
        if b > value {
            value = b
        }
        if c > value {
            value = c
        }
        if d > value {
            value = d
        }
        
        return value
    }
    
    func getDecisionSpeed(rotateSpeed:Double, refusalSpeed:Double) -> Double{
        if rotateSpeed < refusalSpeed{
            decisionSpeed = rotateSpeed
        }
        else{
            decisionSpeed = refusalSpeed
        }
        return decisionSpeed
    }
    
    func getTOR (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, wingSweep: Bool) -> Double {
        var tOR = 0.0
        var OutputIndex = 0
        
        if wingSweep == true {
            OutputIndex = TOLDOutput.TORNorm.rawValue
        }
        else{
            OutputIndex = TOLDOutput.TOROff.rawValue
        }

        tOR = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        print("takeoff Roll is = \(tOR)")
        
        return tOR
      
    }
}

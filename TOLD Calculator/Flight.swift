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
    var twoEngineClimbCorr: TwoEngineClimbCorrection = TwoEngineClimbCorrection()
    var threeEngineClimbCorr: ThreeEngineClimbCorrection = ThreeEngineClimbCorrection()
    var crosswinds: Crosswinds = Crosswinds()
    
    var grossWeight: Double = 0.0
    var wingSweep: Int = 0 // 0 = 15 WS 1 = 20WS 2 = 20WS S/S Off
    var availableRunway: Double = 0.0
    var pressureAltitude: Double = 0.0
    var temperature: Double = 0.0 //temperature in ºF
    var tOF: Double = 0.0
    var unCorrRefusalSpeed: Double = 0.0
    var refusalSpeed: Double = 0.0
    var decisionSpeed: Double = 0.0
    var rotateSpeed: Double = 0.0
    var takeoffSpeed: Double = 0.0
    var unCorrtwoEngineClimb: Double = 0.0
    var unCorrthreeEngineClimb: Double = 0.0
    var brakeCaution: Double = 0.0
    var brakeDanger: Double = 0.0
    var cFL: Double = 0.0
    var refusalSpeedFactor: Double = 0.0
    var test: Double = 0.0
    var twoEngineClimbCorrection: Double = 0.0
    var twoEngineClimb: Double = 0.0
    var threeEngineClimb: Double = 0.0
    var tOR: Double = 0.0
    var takeOffDistance: Double = 0.0
    var rCR: Int = 2

	func process() {
		//only conduct the processing if inputs are within the table limits.
		//This should never be triggered unless everything is validated, but will double check.
		if grossWeight >= 210 && grossWeight <= 420 &&
			temperature  >= -20 && temperature <= 120 &&
			pressureAltitude >= 0 && pressureAltitude <= 6000 &&
			availableRunway >= 8000 && availableRunway <= 13500 {
			
			tOF = tOFTable.getTakeoffFactor(tempF: temperature, altitude: pressureAltitude)
            updateTOFDependants(tof: tOF, gwt: grossWeight, wingSweep: wingSweep, rcr: rCR, temp: temperature)
			takeoffSpeed = speedTable.getTOSpeed(wingSweep: wingSweep, grossWeight: grossWeight)
			rotateSpeed = speedTable.getRotateSpeed(wingsweep: wingSweep, grossWeight: grossWeight)
			decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
			refusalSpeedFactor = rSF.getRefusalFactor(gWt: grossWeight, tOF: tOF)
			refusalSpeed = rS.getRefusalSpeed(availableRunway: availableRunway, refusalFactor: refusalSpeedFactor)
			decisionSpeed = getDecisionSpeed(rotateSpeed: rotateSpeed, refusalSpeed: refusalSpeed)
            //TODO: something is duplicated here.
			unCorrRefusalSpeed = rS.getRefusalSpeed(availableRunway: availableRunway, refusalFactor: refusalSpeedFactor)

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
    
    func updateTOFDependants (tof: Double, gwt: Double, wingSweep: Int, rcr: Int, temp: Double) {
        var i: Int = 0  //gwt index
        var j: Int = 0  //tof index
        
        i = findUpperGWTIndex(gwt: gwt)
        j = findUpperTOFIndex(tof: tof)
        
        //Calculate Percent deltas
        
        let perDeltaGWT: Double = percentDeltaGWT(gwt: gwt)
        let perDeltaTOF: Double = percentDeltaTOF(tof: tof)
        
        threeEngineClimb = correctedThreeEngineClimb(gwt: grossWeight, temp: temperature, gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF, wingSweep: wingSweep)
        
        twoEngineClimb = correctedTwoEngineClimb(gwt: grossWeight, temp: temperature, gwtUpperIndex: i, TOFUpperIndex: j, deltaGWT: perDeltaGWT, deltaTOF: perDeltaTOF, wingSweep: wingSweep)
        
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
        var twoEngineClimb: Double = 0.0
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
    
    func cfl (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, rcr: Int, wingsweep: Int) -> Double {
        var cfl: Double = 0.0
        var OutputIndex: Int = 0
        
        switch rcr {
        case 0:
            OutputIndex = TOLDOutput.CFLIcyNorm.rawValue
        case 1:
            switch wingsweep{
            case 0:
                OutputIndex = TOLDOutput.CFLWetNorm.rawValue    //9 RCR 15WS
            case 1:
                OutputIndex = TOLDOutput.CFLWetNorm.rawValue    //9 RCR 20WS
            case 2:
                OutputIndex = TOLDOutput.CFLWetOff.rawValue     //9 RCR 20WS S/S Off
            default:
                 OutputIndex = TOLDOutput.CFLWetNorm.rawValue   //9 RCR 15WS
            }
        case 2:
            switch wingsweep {
            case 0:
                OutputIndex = TOLDOutput.CFLDryNorm.rawValue    //26 RCR 15 WS
            case 1:
                OutputIndex = TOLDOutput.CFLDryNorm.rawValue    //26 RCR 20 WS
            case 2:
                OutputIndex = TOLDOutput.CFLDryOff.rawValue     //26 RCR 20 WS S/S Off
            default:
                OutputIndex = TOLDOutput.CFLDryNorm.rawValue    //26 RCR 15 WS
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
    
    func getTOR (gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, wingSweep: Int) -> Double {
        var tOR = 0.0
        var OutputIndex = 0
        
        switch wingSweep {
        case 0:
            OutputIndex = TOLDOutput.TORNorm.rawValue     //15 WS TOR
        case 1:
            OutputIndex = TOLDOutput.TORNorm.rawValue     //20 WS TOR
        case 2:
             OutputIndex = TOLDOutput.TOROff.rawValue     //20 WS S/S Off TOR
        default:
            OutputIndex = TOLDOutput.TORNorm.rawValue     //15 WS TOR
        }

        tOR = interpolateIFG(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF, outputIndex: OutputIndex)
        
        print("takeoff Roll is = \(tOR)")
        
        return tOR
      
    }
    
    func correctedTwoEngineClimb (gwt: Double , temp: Double, gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, wingSweep: Int) -> Double{
        
        var correctedTwoEngineClimb: Double = 0
        var uncorrectedTwoEngineClimb: Double = 0
        var twoEngineClimbCorrection: Double = 0
        
        
        uncorrectedTwoEngineClimb = twoEngineClimb(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF)
        twoEngineClimbCorrection = twoEngineClimbCorr.getTwoEngineClimbCorrection(gwt: gwt, temp: temp)
        
        switch wingSweep{
        
        case 0:
            correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection
            
        case 1:
            if (twoEngineClimbCorrection > 1500){
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection + 25
            } else if (twoEngineClimbCorrection < 500){
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection - 25
            } else {
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection
            }
        
        case 2:
            if (twoEngineClimbCorrection > 1500){
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection + 25
            } else if (twoEngineClimbCorrection < 500){
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection - 25
            } else {
                correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection
            }
        default:
            correctedTwoEngineClimb = uncorrectedTwoEngineClimb + twoEngineClimbCorrection
        }
        return correctedTwoEngineClimb
    }
    
    func correctedThreeEngineClimb (gwt: Double , temp: Double, gwtUpperIndex: Int, TOFUpperIndex: Int, deltaGWT: Double, deltaTOF: Double, wingSweep: Int) -> Double{
        
        var correctedThreeEngineClimb: Double = 0
        var uncorrectedThreeEngineClimb: Double = 0
        var threeEngineClimbCorrection: Double = 0
        
        
        uncorrectedThreeEngineClimb = threeEngineClimb(gwtUpperIndex: gwtUpperIndex, TOFUpperIndex: TOFUpperIndex, deltaGWT: deltaGWT, deltaTOF: deltaTOF)
        threeEngineClimbCorrection = threeEngineClimbCorr.getThreeEngineClimbCorrection(gwt: gwt, temp: temp)
        
        switch wingSweep{
            
        case 0:
            correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection
            
        case 1:
            if (threeEngineClimbCorrection > 1500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection + 25
            } else if (threeEngineClimbCorrection < 500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection - 25
            } else {
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection
            }
            
        case 2:
            if (threeEngineClimbCorrection > 1500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection + 25
            } else if (threeEngineClimbCorrection < 500){
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection - 25
            } else {
                correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection
            }
        default:
            correctedThreeEngineClimb = uncorrectedThreeEngineClimb + threeEngineClimbCorrection
        }
        return correctedThreeEngineClimb
    }
}

//
//  TOLDOutput.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/22/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import Foundation

enum TOLDOutput: Int {
    //        index 0 = TOR Norm
    //        index 1 = TOR 20 WS S/S OFF
    //        index 2 = Climb 3 engines
    //        index 3 = Climb 2 engines
    //        index 4 = Break CAUTION
    //        index 5 = Break DANGER
    //        index 6 = CFL dry (26) NORM
    //        index 7 = CFL dry (26) 20 WS S/S OFF
    //        index 8 = CFL wet (12) NORM
    //        index 9 = CFL wet (12) 20 WS S/S OFF
    //        index 10 = CFL icy (9) NORM
    case TORNorm = 0
    case TOROff = 1
    case Climb3Engines = 2
    case Climb2Engines = 3
    case BreakCaution = 4
    case BreakDanger = 5
    case CFLDryNorm = 6
    case CFLDryOff = 7
    case CFLWetNorm = 8
    case CFLWetOff = 9
    case CFLIcyNorm = 10
}

//
//  TOLDViewController.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/1/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import UIKit

class TOLDViewController: UIViewController {

    //Test
    var flight: Flight = Flight()
//    var tOF: TakeoffFactors = TakeoffFactors()
//    var speedTable: SpeedTable = SpeedTable()
//    var maxAB: MaxAB = MaxAB()
    
    @IBOutlet weak var temperature: UITextField!
    @IBOutlet weak var tempPlusOrMinus: UISegmentedControl!
    @IBOutlet var TOLDView: UIView!
    @IBOutlet weak var pressureAltitude: UITextField!
    @IBOutlet weak var CelciusVsFahrenheit: UISegmentedControl! //0 = C, 1 = F Default C
    @IBOutlet weak var threeEngClimb: UILabel!
    @IBOutlet weak var twoEngClimb: UILabel!
    @IBOutlet weak var brakeDanger: UILabel!
    @IBOutlet weak var brakeCaution: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stylize()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grossWeightDidBeginEditing(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
        if sender.backgroundColor != nil {
            sender.backgroundColor = nil
        }
    }
    
    @IBAction func wingSweepDidChange(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0: flight.wingSweep = true
        case 1: flight.wingSweep = false
        default: flight.wingSweep = true
        }
//        flight.rotateSpeed = speedTable.getRotateSpeed(wingsweep: flight.wingSweep, grossWeight: flight.grossWeight)
//        flight.takeoffSpeed = speedTable.getTOSpeed(wingSweep: flight.wingSweep, grossWeight: flight.grossWeight)
    }

    @IBAction func grossWeightDidEndEditing(_ sender: UITextField) {
        flight.grossWeight = Double(sender.text!)!
        //TODO: For testing only
//        speedTable.findGrossWeightIndex(grossWeight: flight.grossWeight)
//        flight.rotateSpeed = speedTable.getRotateSpeed(wingsweep: flight.wingSweep, grossWeight: flight.grossWeight)
//        flight.takeoffSpeed = speedTable.getTOSpeed(wingSweep: flight.wingSweep, grossWeight: flight.grossWeight)
        
        refresh()
    }
    
    @IBAction func temperatureEditingDidBegin(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
        if sender.backgroundColor != nil {
            sender.backgroundColor = nil
        }
    }
    
    @IBAction func temperatureEditingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
            sender.backgroundColor = UIColor.TOLDColor.TOLDRed
        }
        flight.temperature = flight.setTemperature(temp: sender.text!, cORf: CelciusVsFahrenheit.selectedSegmentIndex)
        if tempPlusOrMinus.selectedSegmentIndex == 1 {
            flight.temperature *= -1
        }
        refresh()
    }
        
    @IBAction func pressureAltitudeEditingDidBegin(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
        refresh()
    }
    
    @IBAction func pressureAltitudeEditingDidEnd(_ sender: UITextField) {
        flight.pressureAltitude = Double(sender.text!)!
        
        refresh()
    }
    
    func stylize() {
        TOLDView.backgroundColor = UIColor.TOLDColor.Gold
        CelciusVsFahrenheit.tintColor = UIColor.TOLDColor.TOLDBlue
    }
    
    func refresh() {
        self.threeEngClimb.text = String(Int(flight.threeEngineClimb))
        self.twoEngClimb.text = String(Int(flight.twoEngineClimb))
        self.brakeCaution.text = String(Int(flight.brakeCaution))
        self.brakeDanger.text = String(Int(flight.brakeDanger))
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

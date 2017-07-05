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
    var tOF: TakeoffFactors = TakeoffFactors()
    var speedTable: SpeedTable = SpeedTable()
    
    @IBOutlet weak var temperature: UITextField!
    @IBOutlet weak var pressureAltitude: UITextField!
    @IBOutlet weak var CelciusVsFahrenheit: UISegmentedControl! //0 = C, 1 = F Default C

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grossWeightDidBeginEditing(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
    }
    
    @IBAction func wingSweepDidChange(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0: flight.wingSweep = true
        case 1: flight.wingSweep = false
        default: flight.wingSweep = true
        }
    }

    @IBAction func grossWeightDidEndEditing(_ sender: UITextField) {
        flight.grossWeight = Double(sender.text!)!
        //For testing only
        speedTable.findGrossWeightIndex(grossWeight: flight.grossWeight)
        flight.rotateSpeed = speedTable.getRotateSpeed(wingsweep: flight.wingSweep, grossWeight: flight.grossWeight)
    }
    
    @IBAction func temperatureEditingDidBegin(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
    }
    
    @IBAction func temperatureEditingDidEnd(_ sender: UITextField) {
        var testIndex: Int = 0
        flight.temperature = flight.setTemperature(temp: sender.text!, cORf: CelciusVsFahrenheit.selectedSegmentIndex)
        testIndex = tOF.findFirstTempIndex(tempF: flight.temperature)
        
    }
        
    @IBAction func pressureAltitudeEditingDidBegin(_ sender: UITextField) {
        if sender.text == "0" {
            sender.text = ""
        }
    }
    
    @IBAction func pressureAltitudeEditingDidEnd(_ sender: UITextField) {
        var testIndex: Int = 0
        flight.pressureAltitude = Double(sender.text!)!
        testIndex = tOF.findFirstAltitudeIndex(altitude: flight.pressureAltitude)
        print(testIndex)
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

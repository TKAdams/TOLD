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
        if sender.backgroundColor != nil {
            sender.backgroundColor = nil
        }
    }
    
    @IBAction func grossWeightDidEndEditing(_ sender: UITextField) {
        flight.grossWeight = Double(sender.text!)!
        //TODO: For testing only
        speedTable.findGrossWeightIndex(grossWeight: flight.grossWeight)
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
        var testIndex: Int = 0
        if sender.text == "" {
            sender.text = "0"
            sender.backgroundColor = UIColor.red
        }
        flight.temperature = flight.setTemperature(temp: sender.text!, cORf: CelciusVsFahrenheit.selectedSegmentIndex)
        
        //TODO: Remove once implemented
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
        
        //TODO: Remove once code implemented
        testIndex = tOF.findFirstAltitudeIndex(altitude: flight.pressureAltitude)
        var testTOF = tOF.getTakeoffFactor(tempF: flight.temperature, altitude: flight.pressureAltitude)
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

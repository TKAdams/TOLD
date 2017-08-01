//
//  TOLDViewController.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/1/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import UIKit

class TOLDViewController: UIViewController {

    var flight: Flight = Flight()

    //MARK: - Input variables
    
    @IBOutlet weak var grossWeight: UITextField!
    @IBOutlet weak var temperature: UITextField!
    @IBOutlet weak var tempPlusOrMinus: UISegmentedControl!
    @IBOutlet weak var CelciusVsFahrenheit: UISegmentedControl! //0 = C, 1 = F Default C
    @IBOutlet weak var pressureAltitude: UITextField!
    @IBOutlet weak var fieldLength: UITextField!
    @IBOutlet weak var rCR: UISegmentedControl!
    @IBOutlet weak var wingSweep: UISegmentedControl!
    @IBOutlet var TOLDView: UIView!

    
    //MARK:  - Output variables
    
    @IBOutlet weak var decisionSpeed: UILabel!
    @IBOutlet weak var rotateSpeed: UILabel!
    @IBOutlet weak var takeOffSpeed: UILabel!
    @IBOutlet weak var rS: UILabel!
    @IBOutlet weak var threeEngClimb: UILabel!
    @IBOutlet weak var twoEngClimb: UILabel!
    @IBOutlet weak var brakeCaution: UILabel!
    @IBOutlet weak var brakeDanger: UILabel!
    @IBOutlet weak var cFL: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stylize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Field modifications
    
    @IBAction func grossWeightDidBeginEditing(_ sender: UITextField) {

        editingField(tf: sender)
    }
    
    @IBAction func grossWeightDidEndEditing(_ sender: UITextField) {
        validateField(tf: sender, min: 210.0, max: 420.0)
        flight.grossWeight = Double(sender.text!)!
        
        refresh()
    }
    
    @IBAction func temperatureEditingDidBegin(_ sender: UITextField) {

        editingField(tf: sender)
    }
    
    @IBAction func temperatureEditingDidEnd(_ sender: UITextField) {

        validateField(tf: sender, min: -20.0, max: 120.0)
        flight.temperature = flight.setTemperature(temp: sender.text!, cORf: CelciusVsFahrenheit.selectedSegmentIndex)
        if tempPlusOrMinus.selectedSegmentIndex == 1 {
            flight.temperature *= -1
        }

        refresh()
    }
    
    @IBAction func pressureAltitudeEditingDidBegin(_ sender: UITextField) {
        
        editingField(tf: sender)
    }
    
    @IBAction func pressureAltitudeEditingDidEnd(_ sender: UITextField) {
        
        validateField(tf: sender, min: 0.0, max: 6000.0)
        flight.pressureAltitude = Double(sender.text!)!
        
        refresh()
    }
    
    @IBAction func fieldLengthEditingDidBegin(_ sender: UITextField) {

        editingField(tf: sender)
    }
    
    @IBAction func fieldLengthEditingDidEnd(_ sender: UITextField) {

        validateField(tf: sender, min: 10000, max: 20000)
        flight.takeOffDistance = Double(sender.text!)!
        refresh()
    }

    @IBAction func rCRValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: flight.rCR = 0
        case 1: flight.rCR = 1
        case 2: flight.rCR = 2
        default: flight.rCR = 2
        }
        refresh()
    }
    
    @IBAction func wingSweepDidChange(_ sender: UISegmentedControl){

        switch sender.selectedSegmentIndex {
        case 0: flight.wingSweep = true
        case 1: flight.wingSweep = false
        default: flight.wingSweep = true
        }
        
        refresh()
    }
    
    func editingField(tf: UITextField) {
        if tf.text == "0" {
            tf.text = ""
        }
        if tf.backgroundColor != nil {
            tf.backgroundColor = nil
        }
    }

    func validateField(tf: UITextField, min: Double, max: Double) {
        if tf.text == "" {
            tf.text = "0"
            tf.backgroundColor = UIColor.TOLDColor.Red
        } else {
            if (Double(tf.text!)! < min) || (Double(tf.text!)! > max) {
                tf.backgroundColor = UIColor.TOLDColor.Yellow
            }
        }
    }
    
    func stylize() {
        TOLDView.backgroundColor = UIColor.TOLDColor.Gold
        CelciusVsFahrenheit.tintColor = UIColor.TOLDColor.Blue
        grossWeight.backgroundColor = UIColor.TOLDColor.Red
        temperature.backgroundColor = UIColor.TOLDColor.Red
        pressureAltitude.backgroundColor = UIColor.TOLDColor.Red
        fieldLength.backgroundColor = UIColor.TOLDColor.Red
        
    }
    
    func refresh() {
        self.threeEngClimb.text = String(Int(flight.threeEngineClimb))
        self.twoEngClimb.text = String(Int(flight.twoEngineClimb))
        self.brakeCaution.text = String(Int(flight.brakeCaution))
        self.brakeDanger.text = String(Int(flight.brakeDanger))
        self.cFL.text = String(Int(flight.cFL))
        self.rS.text = String(Int(flight.refusalSpeed))
        self.rotateSpeed.text = String(Int(flight.rotateSpeed))
        self.takeOffSpeed.text = String(Int(flight.takeoffSpeed))
        self.decisionSpeed.text = String(Int(flight.decisionSpeed))
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

//
//  InputTableViewController.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 1/17/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController {
    
    var flight: Flight!
	var parentController: TOLDViewController!

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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Flight = \(flight)")
        stylize()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.TOLDColor.CalcBackground
    }
	
	//MARK: - Field modifications

	@IBAction func grossWeightDidBeginEditing(_ sender: UITextField) {
		editingField(tf: sender)
	}

	@IBAction func grossWeightDidEndEditing(_ sender: UITextField) {
		validateField(tf: sender, min: 210.0, max: 420.0)
		flight.grossWeight = Double(sender.text!)!

		parentController.refresh()
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

		parentController.refresh()
	}

	//    @IBAction func pressureAltitudeEditingDidBegin(_ sender: UITextField) {
	//
	//        editingField(tf: sender)
	//    }
	//
	//    @IBAction func pressureAltitudeEditingDidEnd(_ sender: UITextField) {
	//
	//        validateField(tf: sender, min: 0.0, max: 6000.0)
	//        flight.pressureAltitude = Double(sender.text!)!
	//
	//        refresh()
	//    }
	//
	//    @IBAction func fieldLengthEditingDidBegin(_ sender: UITextField) {
	//
	//        editingField(tf: sender)
	//    }
	//
	//
	//
	//    @IBAction func fieldLengthEditingDidEnd(_ sender: UITextField) {
	//
	//        validateField(tf: sender, min: 9000, max: 20000)
	//        if Int(sender.text!)! > 8000 {
	//            flight.takeOffDistance = Double(sender.text!)!}
	//        else {
	//            sender.text="Invalid Entry"
	//            sender.backgroundColor = UIColor.TOLDColor.Red
	//        }
	//        refresh()
	//    }
	//
	//    @IBAction func rCRValueChanged(_ sender: UISegmentedControl) {
	//        switch sender.selectedSegmentIndex {
	//        case 0: flight.rCR = 0
	//        case 1: flight.rCR = 1
	//        case 2: flight.rCR = 2
	//        default: flight.rCR = 2
	//        }
	//        refresh()
	//    }
	//
	//    @IBAction func wingSweepDidChange(_ sender: UISegmentedControl){
	//
	//        switch sender.selectedSegmentIndex {
	//        case 0: flight.wingSweep = true
	//        case 1: flight.wingSweep = false
	//        default: flight.wingSweep = true
	//        }
	//
	//        refresh()
	//    }
	
	func editingField(tf: UITextField) {
		if (tf.text == "0") || (tf.text == "Invalid Entry") {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
    // MARK: - Appearance
 
    func stylize() {
		tableView.backgroundColor = UIColor.TOLDColor.CalcBackground
		
		//Textfields
		let textFields: [UITextField] = [grossWeight, temperature, pressureAltitude, fieldLength]
		
		for textField in textFields {
			textField.backgroundColor = UIColor.TOLDColor.Red
		}
		
		//Segmented controls
		let buttons: [UISegmentedControl] = [rCR, CelciusVsFahrenheit, tempPlusOrMinus, wingSweep]
		
		for button in buttons {
			button.tintColor = UIColor.TOLDColor.Detail
			button.backgroundColor = UIColor.TOLDColor.ButtonBackground
		}
    }
}


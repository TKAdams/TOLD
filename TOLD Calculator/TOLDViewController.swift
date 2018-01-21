//
//  TOLDViewController.swift
//  TOLD Calculator
//
//  Created by TODD WILSON on 7/1/17.
//  Copyright © 2017 TODD WILSON. All rights reserved.
//

import UIKit

class TOLDViewController: UIViewController {

    var flight: Flight! //= Flight()
    
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
  
    // MARK: - View controller delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    func outputValue (number: Double) -> String {
        var value: String = ""
        
        switch number {
        case 100001:
            value = "N/A"
        case 100002:
            value = "No Data"
        case 100003:
            value = "----"
        default:
            value = String(Int(number))
        }
        
        return value
    }
    
    func stylize() {
        TOLDView.backgroundColor = UIColor.TOLDColor.CalcBackground
    }
    
    func refresh() {
        self.threeEngClimb.text = outputValue(number: flight.threeEngineClimb)
        self.twoEngClimb.text = outputValue(number: flight.twoEngineClimb)
        self.brakeCaution.text = outputValue(number: flight.brakeCaution)
        self.brakeDanger.text = outputValue(number: flight.brakeDanger)
        self.cFL.text = outputValue(number: flight.cFL)
        self.rS.text = String(Int(flight.refusalSpeed))
        self.rotateSpeed.text = String(Int(flight.rotateSpeed))
        self.takeOffSpeed.text = String(Int(flight.takeoffSpeed))
        self.decisionSpeed.text = String(Int(flight.decisionSpeed))
    }
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedInput" {
            let controller = segue.destination as! InputTableViewController
            controller.flight = flight
			controller.parentController = segue.source as! TOLDViewController
        }
    }

}

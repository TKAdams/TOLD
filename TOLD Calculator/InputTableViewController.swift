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
        CelciusVsFahrenheit.tintColor = UIColor.TOLDColor.Blue
        grossWeight.backgroundColor = UIColor.TOLDColor.Red
        temperature.backgroundColor = UIColor.TOLDColor.Red
        pressureAltitude.backgroundColor = UIColor.TOLDColor.Red
        fieldLength.backgroundColor = UIColor.TOLDColor.Red
        tableView.backgroundColor = UIColor.TOLDColor.CalcBackground
    }
}


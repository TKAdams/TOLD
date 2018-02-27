//
//  BONETOLDViewController.swift
//  TOLD Calculator
//
//  Created by Travis Adams on 2/25/18.
//  Copyright © 2018 TODD WILSON. All rights reserved.
//

import UIKit

class BONETOLDViewController: UIViewController {

    @IBOutlet weak var decisionSpeed: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decisionSpeed.layer.borderWidth = CGFloat(Float(10.0))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

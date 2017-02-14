//
//  BidViewController.swift
//  BidEuchre
//
//  Created by Tyler Rose on 2/13/17.
//  Copyright © 2017 Tyler Rose. All rights reserved.
//

import UIKit

class BidViewController: UIViewController {

	// Labels
	@IBOutlet public weak var TitleLbl: UILabel!
	@IBOutlet weak var MessageLbl: UILabel!
	
	// Button Outlets
	@IBOutlet weak var btn1: UIButton!
	@IBOutlet weak var btn2: UIButton!
	@IBOutlet weak var btn3: UIButton!
	@IBOutlet weak var btn4: UIButton!
	@IBOutlet weak var btn5: UIButton!
	@IBOutlet weak var btn6: UIButton!
	@IBOutlet weak var btn7: UIButton!
	
	// Button Functions
	@IBAction func btnPushed(_ sender: UIButton) {
		
	}
	
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

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

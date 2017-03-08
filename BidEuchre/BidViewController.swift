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
	@IBOutlet weak var TitleLbl: UILabel!
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

	// Setup the view
	func setupView(title: String, message: String, currentBid: Int) {
		TitleLbl.text = title
		
		// Need a different message if no one has bid yet
		if currentBid > 2 {
			MessageLbl.text = message
		} else {
			MessageLbl.text = "No one has bid yet"
		}
		
		// Need to check if we are the last bidder and are forced to bid
		var forceBid = false
		if Owner.Player_1 == Owner(rawValue: (Trick.getInstance().GetLeadPlayer().rawValue + 3) % 4)! && currentBid > 2{
			forceBid = true
		}
		
		if currentBid < 3 {
			btn1.setTitle("Pass", for: .normal)
			btn2.setTitle("3", for: .normal)
			btn3.setTitle("4", for: .normal)
			btn4.setTitle("5", for: .normal)
			btn5.setTitle("Shoot", for: .normal)
			btn6.setTitle("Alone", for: .normal)
			btn7.isHidden = true
		} else if currentBid == 3 {
			btn1.setTitle("Pass", for: .normal)
			btn2.isHidden = true
			btn3.setTitle("4", for: .normal)
			btn4.setTitle("5", for: .normal)
			btn5.setTitle("Shoot", for: .normal)
			btn6.setTitle("Alone", for: .normal)
			btn7.isHidden = true
		} else if currentBid == 4 {
			btn1.setTitle("Pass", for: .normal)
			btn2.isHidden = true
			btn3.isHidden = true
			btn4.setTitle("5", for: .normal)
			btn5.setTitle("Shoot", for: .normal)
			btn6.setTitle("Alone", for: .normal)
			btn7.isHidden = true
		} else if currentBid == 5 {
			btn1.setTitle("Pass", for: .normal)
			btn2.isHidden = true
			btn3.isHidden = true
			btn4.isHidden = true
			btn5.setTitle("Shoot", for: .normal)
			btn6.setTitle("Alone", for: .normal)
			btn7.isHidden = true
		} else if currentBid == 7 {
			btn1.setTitle("Pass", for: .normal)
			btn2.isHidden = true
			btn3.isHidden = true
			btn4.isHidden = true
			btn5.isHidden = true
			btn6.setTitle("Alone", for: .normal)
			btn7.isHidden = true
		}
		
		// Disable the Pass button if we need to be forced to bid
		if forceBid {
			btn1.isHidden = true
		}
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

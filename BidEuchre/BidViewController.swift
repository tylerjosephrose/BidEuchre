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
		let parent = self.parent as! GameViewController
		if sender.currentTitle != "♠️" && sender.currentTitle != "♣️" && sender.currentTitle != "♥️" && sender.currentTitle != "♦️" {
			if sender.currentTitle == "Shoot" {
				parent.setUserBid(bid: 7)
			} else if sender.currentTitle == "Alone" {
				parent.setUserBid(bid: 8)
			} else if sender.currentTitle != "Pass" {
				parent.setUserBid(bid: Int(sender.currentTitle!)!)
			}
			parent.doBidding()
		} else {
			let trick = Trick.getInstance()
			if sender.currentTitle == "♠️" {
				trick.Set(trump: Suit.Spades)
			} else if sender.currentTitle == "♣️" {
				trick.Set(trump: Suit.Clubs)
			} else if sender.currentTitle == "♥️" {
				trick.Set(trump: Suit.Hearts)
			} else if sender.currentTitle == "♦️" {
				trick.Set(trump: Suit.Diamonds)
			}
			trick.SetBidder(owner: .Player_1)
			parent.startPlayCards()
		}
		self.willMove(toParentViewController: nil)
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
	
	// Setup the view for selecting the suit
	func setupSuitView() {
		TitleLbl.text = "Your bid won"
		MessageLbl.text = "What suit would you like?"
		btn1.setTitle("♠️", for: .normal)
		btn2.setTitle("♣️", for: .normal)
		btn3.setTitle("♥️", for: .normal)
		btn4.setTitle("♦️", for: .normal)
		btn5.isHidden = true
		btn6.isHidden = true
		btn7.isHidden = true
	}

	// Setup the view for bidding
	func setupBidView(player: String, currentBid: Int) {
		TitleLbl.text = "Bid Amount?"
		
		// Need a different message if no one has bid yet, shoot, or alone
		if currentBid < 3 {
			MessageLbl.text = "No one has bid yet"
		} else if currentBid == 7 {
			MessageLbl.text = "Player " + player + " is shooting it"
		} else if currentBid == 8 {
			MessageLbl.text = "Player " + player + " is going alone"
		} else {
			MessageLbl.text = "The bid is " + String(currentBid) + " by Player " + player
		}
		
		// Need to check if we are the last bidder and are forced to bid
		var forceBid = false
		if Owner.Player_1 == Owner(rawValue: (Trick.getInstance().GetLeadPlayer().rawValue + 3) % 4)! && currentBid < 3{
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

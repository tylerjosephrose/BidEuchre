//
//  GameViewController.swift
//  BidEuchre
//
//  Created by Tyler Rose on 2/13/17.
//  Copyright © 2017 Tyler Rose. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

	// UI variables
	@IBOutlet weak var startGameBtn: UIButton!
	@IBOutlet weak var card1Var: CardButton!
	@IBOutlet weak var card2Var: CardButton!
	@IBOutlet weak var card3Var: CardButton!
	@IBOutlet weak var card4Var: CardButton!
	@IBOutlet weak var card5Var: CardButton!
	@IBOutlet weak var card6Var: CardButton!
	
	// internal variables
	private var gameStarted = false
	
	
	@IBAction func cardSelected(_ sender: CardButton) {
		if gameStarted == false {
			return
		}
		print("The \(sender.GetCard().Print()) was selected")
		sender.isHidden = true
		Deck.GetInstance().Return(card: sender.GetCard())
	}
	@IBAction func cardHolding(_ sender: CardButton) {
		UIView.animate(withDuration: 0.2, animations: {sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)})
	}
	@IBAction func cardReleased(_ sender: CardButton) {
		UIView.animate(withDuration: 0.2, animations: {sender.transform = CGAffineTransform(scaleX: 1, y: 1)})
	}
	@IBAction func startGamePressed(_ sender: UIButton) {
		gameStarted = true
	}
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	

}

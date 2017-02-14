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
	private var players = [Player(player: .Player_1), Player(player: .Player_2), Player(player: .Player_3), Player(player: .Player_4)]
	private var cardButtons:  [CardButton]!
	
	// bidding variables
	private var playerBid: Owner!
	
	@IBAction func cardSelected(_ sender: CardButton) {
		if gameStarted == false {
			return
		}
		print("The \(sender.GetCard().Print()) was selected")
		sender.isHidden = true
		Deck.GetInstance().Return(card: sender.GetCard())
	}
	@IBAction func cardHolding(_ sender: CardButton) {
		if gameStarted == false {
			return
		}
		UIView.animate(withDuration: 0.2, animations: {sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)})
	}
	@IBAction func cardReleased(_ sender: CardButton) {
		if gameStarted == false {
			return
		}
		UIView.animate(withDuration: 0.2, animations: {sender.transform = CGAffineTransform(scaleX: 1, y: 1)})
	}
	@IBAction func startGamePressed(_ sender: UIButton) {
		startGameBtn.isHidden = true
		gameStarted = true
		cardButtons = [card1Var, card2Var, card3Var, card4Var, card5Var, card6Var]
		Deck.GetInstance().Shuffle()
		
		// Get hand for each player
		for player in players {
			player.GetHand()
		}
		
		// Display the cards to the player
		for i in 0...5 {
			cardButtons[i].SetUp(card: players[0].m_hand[i])
		}
		
		// Figure out bids
		//let lead = Trick.getInstance().GetLeadPlayer()
		var currentBid = 2
		var playerUp = Trick.getInstance().GetLeadPlayer()
		var winningBidder = Owner.InPlay
		for _ in 0...4 {
			if Owner.Player_1 == playerUp {
				askUserBid(currentBid: currentBid, player: winningBidder)
			} else {
				let desiredBid = players[playerUp.rawValue].myAI.AIBid(player: players[playerUp.rawValue], currentBid: currentBid)
				if desiredBid > currentBid {
					currentBid = desiredBid
					winningBidder = playerUp
				}
			}
			playerUp = increase(player: playerUp)
		}
		playerBid = winningBidder
	}
	
	func askUserBid(currentBid: Int, player: Owner) {
		// first we need to set up the overlay with the proper information
		let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbbidViewController") as! BidViewController
		popOverVC.TitleLbl.text = "How much would you like to bid?"
		popOverVC.MessageLbl.text = "The current bid is \(currentBid) by Player \(player.rawValue + 1)"
		
		// all the overlay stuff
		self.addChildViewController(popOverVC)
		popOverVC.view.frame = self.view.frame
		self.view.addSubview(popOverVC.view)
		popOverVC.didMove(toParentViewController: self)
	}
	
	func increase(player: Owner) -> Owner {
		if player != .Player_4 {
			return Owner(rawValue: player.rawValue + 1)!
		} else {
			return .Player_1
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
	
	

}

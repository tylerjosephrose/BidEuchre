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
	private var biddersDone = 4
	private var bidderUp: Owner!
	private var winningBidder = Owner.InPlay
	private var currentBid = 2
	
	// playing variables
	private var playerUp: Owner!
	private var playersDone = 0
	
	// round variables
	private var tricksDone = 0
	private var team1Tricks = 0
	private var team2Tricks = 0
	
	// Set bid from BidViewController
	func setUserBid(bid: Int) {
		currentBid = bid
		winningBidder = Owner.Player_1
		if Owner.Player_1 == Owner(rawValue: (Trick.getInstance().GetLeadPlayer().rawValue + 3) % 4)! {
			winningBidder = Owner.Player_1
		}
	}
	
	@IBAction func cardSelected(_ sender: CardButton) {
		if gameStarted == false {
			return
		}
		print("The \(sender.GetCard().Print()) was selected")
		sender.isHidden = true
		//Deck.GetInstance().Return(card: sender.GetCard())
		Trick.getInstance().Set(card: sender.GetCard())
		startPlayCards()
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
		
		Deck.GetInstance().Shuffle()
		
		// Get hand for each player
		for player in players {
			player.GetHand()
		}
		
		// Display the cards to the player
		for i in 0...5 {
			cardButtons[i].SetUp(card: players[0].m_hand[i])
		}
		
		// Do this before every round of bidding
		bidderUp = Trick.getInstance().GetLeadPlayer()
		biddersDone = 0
		doBidding()
	}
	
	func doBidding() {
		if biddersDone < 4 {
			if Owner.Player_1 == bidderUp {
				askUserBid(currentBid: currentBid, player: winningBidder)
				biddersDone += 1
				bidderUp = increase(player: bidderUp)
				return
			} else {
				let desiredBid = players[bidderUp.rawValue].myAI.AIBid(player: players[bidderUp.rawValue], currentBid: currentBid)
				if desiredBid > currentBid {
					currentBid = desiredBid
					winningBidder = bidderUp
				}
			}
			bidderUp = increase(player: bidderUp)
			biddersDone += 1
			doBidding()
		} else {
			print("Player " + String(winningBidder.rawValue + 1) + " won the bid with " + String(currentBid))
			if winningBidder == Owner.Player_1 {
				// User won the bid
				askUserSuit()
			} else {
				players[winningBidder.rawValue].myAI.AIFinalizeBid()
				startPlayCards()
			}
		}
	}
	
	private func askUserSuit() {
		// get the vc
		let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbbidViewController") as! BidViewController
		
		// setup as child vc
		self.addChildViewController(popOverVC)
		popOverVC.view.frame = self.view.frame
		self.view.addSubview((popOverVC.view)!)
		popOverVC.didMove(toParentViewController: self)
		
		// Finish initializing the popover
		popOverVC.setupSuitView()
	}
	
	private func askUserBid(currentBid: Int, player: Owner) {
		// get the VC
		let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbbidViewController") as! BidViewController
		
		// setup as child VC
		self.addChildViewController(popOverVC)
		popOverVC.view.frame = self.view.frame
		self.view.addSubview((popOverVC.view)!)
		popOverVC.didMove(toParentViewController: self)
		
		// Finish initializing the popover bid controller
		popOverVC.setupBidView(player: "\(player.rawValue + 1)", currentBid: currentBid)
	}
	
	func startPlayCards() {
		let trick = Trick.getInstance()
		if tricksDone < 6 {
			if playersDone == 0 {
				playerUp = trick.GetLeadPlayer()
				print("Trump is:")
				print(Trick.getInstance().GetTrump())
			}
			if playersDone < 4 {
				if playerUp == Owner.Player_1 {
					for card in cardButtons {
						card.isEnabled = true
					}
					playersDone += 1
					playerUp = increase(player: playerUp)
					return
				} else {
					disableCards()
					players[playerUp.rawValue].myAI.AIPlayCard(player: players[playerUp.rawValue])
				}
				playerUp = increase(player: playerUp)
				playersDone += 1
				startPlayCards()
			} else {
				// Stuff to do after cards have been played
				trick.Evaluate()
				playersDone = 0
				tricksDone += 1
				// evaluate and give point to correct team
				if trick.GetWinner() == Owner.Player_1 || trick.GetWinner() == Owner.Player_3 {
					team1Tricks += 1
				} else {
					team2Tricks += 1
				}
				startPlayCards()
			}
		} else {
			// When all tricks have been played
			// Team 1 bid
			if winningBidder == Owner.Player_1 || winningBidder == Owner.Player_3 {
				if team1Tricks > currentBid {
					print("Team 1 scored " + String(team1Tricks) + " points")
					print("Team 2 scored " + String(team2Tricks) + " points")
				} else {
					print("Team 1 scored -" + String(currentBid) + " points")
					print("Team 2 scored " + String(team2Tricks) + " points")
				}
			} else {
				// Team 2 bid
				if team2Tricks > currentBid {
					print("Team 1 scored " + String(team1Tricks) + " points")
					print("Team 2 scored " + String(team2Tricks) + " points")
				} else {
					print("Team 1 scored " + String(team1Tricks) + " points")
					print("Team 2 scored -" + String(currentBid) + " points")
				}
			}
		}
	}
	
	func increase(player: Owner) -> Owner {
		if player != .Player_4 {
			return Owner(rawValue: player.rawValue + 1)!
		} else {
			return .Player_1
		}
	}
	
	private func disableCards() {
		for card in cardButtons {
			card.isEnabled = false
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		cardButtons = [card1Var, card2Var, card3Var, card4Var, card5Var, card6Var]
		card1Var.SetUp(card: Card(value: .Jack, ofSuit: .Hearts))
		card2Var.SetUp(card: Card(value: .Jack, ofSuit: .Diamonds))
		card3Var.SetUp(card: Card(value: .Ace, ofSuit: .Hearts))
		card4Var.SetUp(card: Card(value: .King, ofSuit: .Hearts))
		card5Var.SetUp(card: Card(value: .Queen, ofSuit: .Hearts))
		card6Var.SetUp(card: Card(value: .Ten, ofSuit: .Hearts))
		disableCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	

}

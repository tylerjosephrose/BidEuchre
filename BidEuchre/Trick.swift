//
//  Trick.swift
//  BidEuchre
//
//  Created by Tyler Rose on 2/13/17.
//  Copyright © 2017 Tyler Rose. All rights reserved.
//

import Foundation

class Trick {
	private func ReturnCards() {
		let deck = Deck.GetInstance()
		for cards in m_trick {
			deck.Return(card: cards)
		}
		m_trick.removeAll()
	}
	
	private var m_trick = [Card]()
	private var m_leadSuit: Suit?
	private var m_leadPlayer: Owner?
	private var m_trump: Suit?
	private var m_winner: Owner?
	private var m_bidder: Owner?
	private static var m_trickInstance: Trick!
	
	init() {
		m_leadPlayer = Owner(rawValue: Int(arc4random_uniform(4)))
	}
	
	func GetLeadSuit() -> Suit {
		return m_leadSuit!
	}
	
	func GetLeadPlayer() -> Owner {
		return m_leadPlayer!
	}
	
	func GetTrump() -> Suit {
		return m_trump!
	}
	
	func GetLeft() -> Suit {
		switch m_trump! {
		case .Hearts: return Suit.Diamonds
		case .Spades: return Suit.Clubs
		case .Diamonds: return Suit.Hearts
		case .Clubs: return Suit.Spades
		case .High: return Suit.High
		case .Low: return Suit.Low
		}
	}
	
	static func GetLeft(suit: Suit) -> Suit {
		switch suit {
		case .Hearts: return Suit.Diamonds
		case .Spades: return Suit.Clubs
		case .Diamonds: return Suit.Hearts
		case .Clubs: return Suit.Spades
		case .High: return Suit.High
		case .Low: return Suit.Low
		}
	}
	
	func GetWinner() -> Owner {
		return m_winner!
	}
	
	func GetBidder() -> Owner {
		return m_bidder!
	}
	
	func Evaluate() {
		//PrintTrick()
		print()
		assert(m_trick.count > 2 && m_trick.count < 5, "There needs to be either 3 or 4 cards in the trick to evaluate!")
		
		var Highest = m_trick[0]
		
		let rightBar = Card(value: Value.Jack, ofSuit: m_trump!)
		let leftBar = Card (value: Value.Jack, ofSuit: GetLeft())
		
		if Highest == rightBar {
			m_winner = Highest.GetOwner()
			print("\(Highest.OwnerToString()) is the winner with \(Highest.Print())")
			ReturnCards()
			return
		}
		if m_trump != Suit.High && m_trump != Suit.Low {
			for cards in m_trick {
				if cards == rightBar {
					Highest = cards
					m_winner = Highest.GetOwner()
					print("\(Highest.OwnerToString()) is the winner with \(Highest.Print())")
					ReturnCards()
					return
				}
				
				// for non trump find highest
				if cards.GetSuit() == Highest.GetSuit() && Highest.GetSuit() != m_trump && cards != leftBar && Highest != leftBar {
					if cards.GetValue().rawValue > Highest.GetValue().rawValue {
						Highest = cards
					}
				}
				// for trump
				if cards.GetSuit() == m_trump || cards == leftBar {
					// currently no trump laid and this is trump
					if Highest.GetSuit() != m_trump && Highest != leftBar {
						Highest = cards
					}
						// for trump vs trump
					else {
						if cards == leftBar {
							Highest = cards
						}
						else if cards.GetValue().rawValue > Highest.GetValue().rawValue && Highest != leftBar {
							Highest = cards
						}
					}
				}
			}
		}
		else if m_trump == Suit.High {
			for cards in m_trick {
				if cards.GetSuit() == Highest.GetSuit() {
					if cards.GetValue().rawValue > Highest.GetValue().rawValue {
						Highest = cards
					}
				}
			}
		}
		else {
			for cards in m_trick {
				if cards.GetSuit() == Highest.GetSuit() {
					if cards.GetValue().rawValue < Highest.GetValue().rawValue {
						Highest = cards
					}
				}
			}
		}
		m_winner = Highest.GetOwner()
		m_leadPlayer = m_winner
		print("\(Highest.OwnerToString()) of \(Highest.Print())")
		ReturnCards()
	}
	
	func SetLead(suit: Suit) {
		m_leadSuit = suit
	}
	
	func SetLeadPlayer(owner: Owner) {
		m_leadPlayer = owner
	}
	
	func Set(card: Card) {
		// Keep current owner so we can declare winner
		
		
		print(card.Print() + " by Player " + String(card.GetOwner().rawValue + 1))
		
		
		m_trick.append(card)
		if m_trick.count == 1 {
			if card.GetValue() == Value.Jack && card.GetSuit() == GetLeft() {
				SetLead(suit: m_trump!)
			}
			else {
				SetLead(suit: card.GetSuit())
			}
		}
	}
	
	func Set(trump: Suit) {
		m_trump = trump
	}
	
	func SetBidder(owner: Owner) {
		m_bidder = owner
	}
	
	func PrintTrick() {
		for cards in m_trick {
			print("\(cards.ValueToString()) of \(cards.SuitToString()) from \(cards.OwnerToString())")
		}
	}
	
	static func getInstance() -> Trick {
		if m_trickInstance == nil {
			m_trickInstance = Trick()
		}
		// Because of the statement above, this should never return nil
		return m_trickInstance!
	}
}

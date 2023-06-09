//
//  ViewController.swift
//  PlayingCards
//
//  Created by Steven Morin on 08/06/2023.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 1...10 {
            if let card = deck.draw() {
                print(card)
            }
            
        }
        
    }


}


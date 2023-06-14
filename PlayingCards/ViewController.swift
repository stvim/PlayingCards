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
//            if let card = deck.draw() {
//                print(card)
//            }
            
        }
        
    }
    
    @IBOutlet weak var playingCardView: PlayingCardView!
    { didSet {
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(playingCardViewPan))
//        playingCardView.addGestureRecognizer(panGestureRecognizer)
        
        
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnCard(gesture:)))
        swipeGest.direction = [.right,.left,.up,.down]
        playingCardView.addGestureRecognizer(swipeGest)
        
        let pinchGest = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
        playingCardView.addGestureRecognizer(pinchGest)
    }}
    @IBAction func tapOnCard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            getNewCard()
        }
    }
    
    @objc func playingCardViewPan(recognizer:UIPanGestureRecognizer) {
        switch(recognizer.state) {
        case .began,.changed: playingCardView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.04892789077, alpha: 1)
        case .ended:
            fallthrough
        default: playingCardView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
    }
    
    @objc func swipeOnCard(gesture:UISwipeGestureRecognizer) {
        print(gesture.state.rawValue)
        switch(gesture.state) {
        case .began,.changed:
            playingCardView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.04892789077, alpha: 1)
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp;
            fallthrough
        
        default: playingCardView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
    }
    func getNewCard() {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
}


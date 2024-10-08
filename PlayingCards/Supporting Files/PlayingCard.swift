//
//  PlayingCards.swift
//  PlayingCards
//
//  Created by Steven Morin on 08/06/2023.
//

import Foundation

struct PlayingCard : CustomStringConvertible {
    var description: String { "\(suit)\(rank)"}

    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        var description: String { return self.rawValue }
        
        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades, .hearts, .diamonds,.clubs]
    }
    
    enum Rank : CustomStringConvertible {
        var description: String {
            switch (self) {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all : [Rank] {
            var all = [Rank.ace]
            for pips in 2...10 {
                all.append(Rank.numeric(pips))
            }
            all += [Rank.face("J"),.face("Q"),.face("K")]
            return all
        }
    }
}

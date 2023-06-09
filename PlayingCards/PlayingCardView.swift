//
//  PlayingCardView.swift
//  PlayingCards
//
//  Created by Steven Morin on 09/06/2023.
//

import UIKit

class PlayingCardView: UIView {
    var pips:Int = 5 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var suit:String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay(); setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        var roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.white.setFill()
        roundedRect.fill()
        roundedRect.addClip()
    }
    
    var upperCardLabel : UILabel
    var lowerCardLabel : UILabel
    
    private func createCardLabel(label:String) -> UILabel {
        var label = UILabel(frame: CGRect(x: offsetForRoundedCorner, y: offsetForRoundedCorner, width: 0, height: 0))
        
    }
    
    
//    override func draw(_ rect: CGRect) {
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.stroke()
//            context.fillPath()
//        }
//
//        // method 2
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 50.0, startAngle: CGFloat.pi/4, endAngle: CGFloat.pi*3/4, clockwise: true)
//        path.lineWidth = 3.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.stroke()
//        path.fill()
//    }

}

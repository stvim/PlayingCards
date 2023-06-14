//
//  PlayingCardView.swift
//  PlayingCards
//
//  Created by Steven Morin on 09/06/2023.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable
    var rank:Int = 5 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit:String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp:Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale:CGFloat = SizeRatio.faceCardImageSizeToBoundsHeight  { didSet { setNeedsDisplay() } }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        if !isFaceUp {
            switch(recognizer.state) {
            case .changed, .ended:
                faceCardScale *= recognizer.scale
                recognizer.scale = 1.0
            default: break
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCardLabel(upperCardLabel)
        upperCardLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCardLabel(lowerCardLabel)
//        lowerCardLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        lowerCardLabel.transform = CGAffineTransform.identity
//            .translatedBy(x: lowerCardLabel.frame.width, y: lowerCardLabel.frame.height)
            .rotated(by: CGFloat.pi)
        lowerCardLabel.frame.origin = bounds.bottomRight
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerCardLabel.frame.width, dy: -lowerCardLabel.frame.height)
    }
    
    override func draw(_ rect: CGRect) {
        var roundedRect = UIBezierPath(roundedRect: bounds.zoom(by: SizeRatio.cardSizeToViewSize), cornerRadius: 16.0)
        UIColor.white.setFill()
        roundedRect.fill()
        roundedRect.addClip()
        
        if isFaceUp {
            drawPips()
        } else {
            if let cardBackImage = UIImage(named: "Leo_1000") {
                cardBackImage.draw(in: bounds.zoom(by: faceCardScale))
            }
        }
    }
    
    @IBAction func btnSwitchClic(_ sender: UIButton) {
        isFaceUp = !isFaceUp
        
    }
    lazy var upperCardLabel = createCardLabel()
    lazy var lowerCardLabel = createCardLabel()
    
    private func createCardLabel() -> UILabel {
        var label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCardLabel(_ label:UILabel) {
        label.attributedText = cornerAttributedString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    private var cornerAttributedString:NSAttributedString {
        cardLabelAttributedString("\(rankString)\n\(suit)", fontSize: cornerFontSize)
    }
    private func cardLabelAttributedString(_ label:String, fontSize:CGFloat) -> NSAttributedString {
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes : [NSAttributedString.Key:Any] = [
            .paragraphStyle:paragraphStyle,
            .font:font
        ]
        
        return NSAttributedString(string: label, attributes: attributes)
        
    }
    
    
    private func drawPips () {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce (0) { max ($1.count, $0) })
            let maxHorizontalPipCount = CGFloat (pipsPerRowForRank.reduce (0) { max ($1.max () ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = cardLabelAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height /
                                                                         verticalPipRowSpacing)
            let probablyOkayPipString = cardLabelAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return cardLabelAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount) ))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerAttributedString.size().width, dy: cornerAttributedString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight : CGFloat = 0.07
        static let cornerFontSizeToBoundsHeight : CGFloat = 0.065
        static let cornerOffsetToCornerRadius : CGFloat = 0.33
        static let faceCardImageSizeToBoundsHeight : CGFloat = 0.75
        static let cardSizeToViewSize : CGFloat = 0.98
    }
    
    var cornerRadius : CGFloat {
        bounds.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    var cornerFontSize : CGFloat {
        bounds.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    var cornerOffset : CGFloat {
        cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    var rankString : String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: dx+x, y: dy+y)
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

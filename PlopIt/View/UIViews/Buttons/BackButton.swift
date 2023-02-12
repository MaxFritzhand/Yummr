//
//  BackButton.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/12/2021.
//

import UIKit

enum BackButtonType {
    case cross
    case downArrow
    case leftArrow
}

class BackButton: UIButton {
    var path: UIBezierPath!
    var colour = UIColor(white: 1, alpha: 0.7)
    var type: BackButtonType = .downArrow
    
    var padding: CGFloat = 2.0
    var lineWidth: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(withType type: BackButtonType) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createCross() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: self.frame.size.width - padding, y: self.frame.size.height - padding))
        path.move(to: CGPoint(x: self.frame.size.width - padding, y: padding))
        path.addLine(to: CGPoint(x: padding, y: self.frame.size.height - padding))
    }
    
    
    func createDownArrow() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: padding))
        path.addLine(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2))
        path.addLine(to: CGPoint(x: self.frame.size.width - padding, y: padding))
    }
    
    func createLeftArrow() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: padding, y: self.frame.size.height / 2))
        path.addLine(to: CGPoint(x: self.frame.size.width - padding, y: self.frame.size.height / 2))
        
        path.move(to: CGPoint(x: padding, y: self.frame.size.height / 2))
        path.addLine(to: CGPoint(x: self.frame.size.width / 3, y: self.frame.size.height / 4))
        
        path.move(to: CGPoint(x: padding, y: self.frame.size.height / 2))
        path.addLine(to: CGPoint(x: self.frame.size.width / 3, y: 3 * self.frame.size.height / 4))
    }
    
    override func draw(_ rect: CGRect) {
        
        if type == .downArrow  {
            self.createDownArrow()
        } else if type == .cross {
            self.createCross()
        } else if type == .leftArrow {
            self.createLeftArrow()
        }
        colour.setStroke()
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        path.stroke()
    }

}

//
//  UIView_Extension.swift
//  Crispin_Orthotics
//
//  Created by Raivis Olehno on 15/12/2021.
//

import UIKit
import Foundation

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addCornerRadius(value: CGFloat) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    
    func addBorder(withColor color: UIColor, width: CGFloat = 2.0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addShadow(withColor color: UIColor = UIColor.black.withAlphaComponent(0.1), withShadowRadius radius: CGFloat = 2, hasOffset: Bool = false) {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1.0
        
        if hasOffset {
            self.layer.shadowOffset = CGSize(width: 0, height: -2)
        } else {
           self.layer.shadowOffset = .zero
        }
        
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func showLoader(_ color:UIColor?){
        
        let LoaderView  = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        LoaderView.tag = -888754
        LoaderView.backgroundColor = color
        let Loader = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        Loader.center = LoaderView.center
        Loader.style = UIActivityIndicatorView.Style.large
        Loader.color = .systemOrange
        Loader.startAnimating()
        LoaderView.addSubview(Loader)
        self.addSubview(LoaderView)
    }

    func dismissLoader() {
        self.viewWithTag(-888754)?.removeFromSuperview()
    }
    
    
}

extension UIButton {
    
    func setup() {
        self.startAnimatingPressActions()
        self.adjustsImageWhenHighlighted = false
    }
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
        }, completion: nil)
    }
    
}

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
    
    func addInterlineSpacing(spacingValue: CGFloat = 2) {

           // MARK: - Check if there's any text
           guard let textString = text else { return }

           // MARK: - Create "NSMutableAttributedString" with your text
           let attributedString = NSMutableAttributedString(string: textString)

           // MARK: - Create instance of "NSMutableParagraphStyle"
           let paragraphStyle = NSMutableParagraphStyle()

           // MARK: - Actually adding spacing we need to ParagraphStyle
           paragraphStyle.lineSpacing = spacingValue

           // MARK: - Adding ParagraphStyle to your attributed String
           attributedString.addAttribute(
               .paragraphStyle,
               value: paragraphStyle,
               range: NSRange(location: 0, length: attributedString.length
           ))

           // MARK: - Assign string that you've modified to current attributed Text
           attributedText = attributedString
       }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

         guard let labelText = self.text else { return }

         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineSpacing = lineSpacing
         paragraphStyle.lineHeightMultiple = lineHeightMultiple

         let attributedString:NSMutableAttributedString
         if let labelattributedText = self.attributedText {
             attributedString = NSMutableAttributedString(attributedString: labelattributedText)
         } else {
             attributedString = NSMutableAttributedString(string: labelText)
         }

         // (Swift 4.2 and above) Line spacing attribute
         attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


         // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

         self.attributedText = attributedString
     }
}


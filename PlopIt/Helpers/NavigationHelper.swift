//
//  NavigationHelper.swift
//  Crispin_Orthotics
//
//  Created by Raivis Olehno on 15/12/2021.
//

import UIKit

class NavigationHelper: NSObject {
    
    func setupNavBar(forViewController vc: UIViewController, withTintColor tintColor: UIColor = .black, withBackgroundColor backgroundColour: UIColor = .white, backBottomPadding: CGFloat = 8.0) {
        let image = UIImage()
        var backImage = ImageHelper.backImage()
        let navBar = vc.navigationController?.navigationBar
        navBar?.setBackgroundImage(image, for: UIBarMetrics.default)
        navBar?.tintColor = tintColor
        navBar?.backgroundColor = backgroundColour
        navBar?.isTranslucent = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColour
        appearance.shadowColor = .clear
        
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        
        let leftPadding: CGFloat = 10
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(width:backImage.size.width + leftPadding, height:backImage.size.height + backBottomPadding)
        
        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        backImage.draw(at: CGPoint(x: leftPadding,y: 0))
        backImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar?.backIndicatorImage = backImage
        navBar?.backIndicatorTransitionMaskImage = backImage
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(NavigationHelper.popViewController(forViewController:)))
    }
    
    @objc func popViewController(forViewController vc: UIViewController) {
        DispatchQueue.main.async {
            vc.navigationController?.popViewController(animated: false)
        }
    }
    
    func addTitleView(forViewController vc: UIViewController, forTitle title: String, withColor color: UIColor = .white, size: CGFloat = 18.0) {
        let navLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250.0, height: 28.0))
        let title = NSMutableAttributedString(string: title, attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: size)!, NSAttributedString.Key.foregroundColor: color])
        navLabel.textAlignment = .center
        navLabel.attributedText = title
        let totalView = UIView(frame: CGRect(x: 0, y: 0, width: 250.0, height: 68.0))
        totalView.addSubview(navLabel)
        vc.navigationItem.titleView = totalView
    }
    
    func addPatientTitleView(forViewController vc: UIViewController, forTitle title: String, withColor color: UIColor = .white, size: CGFloat = 22.0) {
        let navLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250.0, height: 28.0))
        let title = NSMutableAttributedString(string: title, attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: size)!, NSAttributedString.Key.foregroundColor: color])
        navLabel.textAlignment = .center
        navLabel.attributedText = title
        let totalView = UIView(frame: CGRect(x: 0, y: 0, width: 250.0, height: 68.0))
        totalView.addSubview(navLabel)
        vc.navigationItem.titleView = totalView
    }
    
    func addImageTitle(withImage image: UIImage?, onViewController vc: UIViewController) {
        
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: -7), size: CGSize.init(width: 38, height:38))
        let titleView:UIView = UIView.init(frame: rect)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0.0, width: 115, height: 115)
        imageView.center = CGPoint.init(x: titleView.center.x, y: titleView.center.y)
        imageView.contentMode = .scaleAspectFit
        titleView.addSubview(imageView)
        vc.navigationItem.titleView = titleView
    }
    
    func addRightBarItemText(forViewController vc: UIViewController, withText text: String, withSelector selector: Selector?, tintColor: UIColor) {
        let button = UIBarButtonItem(title: text, style: .plain, target: vc, action: selector)
        button.tintColor = tintColor
        vc.navigationItem.rightBarButtonItem = button
    }
    
    func addLeftBarItemText(toViewController vc: UIViewController, withSelector selector: Selector, withText text: String) {
        let totalView = UIView(frame: CGRect(x: 0, y: -15, width: 60, height: 60))
        let button1 = UIButton(frame: CGRect(x: 0, y: -15, width: 60, height: 60))
        button1.setTitle(text, for: .normal) 
        button1.addTarget(vc, action: selector, for: .touchUpInside)
        totalView.addSubview(button1)
        let barButton = UIBarButtonItem(customView: totalView)
        vc.navigationItem.leftBarButtonItem = barButton
    }
    
    func addRightBarItemText(toViewController vc: UIViewController, withSelector selector: Selector, withText text: String) {
        let totalView = UIView(frame: CGRect(x: 0, y: -15, width: 60, height: 60))
        let button1 = UIButton(frame: CGRect(x: 0, y: -15, width: 60, height: 60))
        button1.setTitle(text, for: .normal)
        button1.addTarget(vc, action: selector, for: .touchUpInside)
        totalView.addSubview(button1)
        let barButton = UIBarButtonItem(customView: totalView)
        vc.navigationItem.rightBarButtonItem = barButton
    }
    
    func removeRightBarItem(forViewController vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem = nil
    }
    
    func addCross(toViewController vc: UIViewController, colour: UIColor = Colours.darkGrey, withSelector selector: Selector, height: Int = 35) {
        let totalView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: height))
        let button1 = BackButton(withType: .cross)
        button1.setup()
        button1.colour = colour
        button1.addTarget(vc, action: selector, for: .touchUpInside)
        totalView.addSubview(button1)
        let barButton = UIBarButtonItem(customView: totalView)
        vc.navigationItem.rightBarButtonItem = barButton
    }
    
    func addBack(toViewController vc: UIViewController, colour: UIColor = .white, withSelector selector: Selector, height: Int = 35) {
        let totalView = UIView(frame: CGRect(x: -7, y: -8, width: 20, height: 20))
        let button1 = UIButton(frame: CGRect(x: -7, y: -8, width: 36, height: 20))
        button1.setup()
        button1.setImage(ImageHelper.backImage(), for: .normal)
        button1.addTarget(vc, action: selector, for: .touchUpInside)
        totalView.addSubview(button1)
        let barButton = UIBarButtonItem(customView: totalView)
        vc.navigationItem.leftBarButtonItem = barButton
    }
    
    
    
    func addShadow(to vc: UIViewController) {
        vc.navigationController?.navigationBar.layer.masksToBounds = false
        vc.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        vc.navigationController?.navigationBar.layer.shadowOpacity = 0.08
        vc.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        vc.navigationController?.navigationBar.layer.shadowRadius = 9
    }
    
    func removeShadow(on vc: UIViewController) {
        vc.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func addMenuItems(toViewController vc: UIViewController, withMenuSelector menuSelector: Selector) {
        let menu = self.barItem(toViewController: vc, withSelector: menuSelector, withImage: ImageHelper.backImage(), width: 18, height: 15)
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 15.0
        let logo = self.barItem(toViewController: vc, withSelector: menuSelector, withImage: ImageHelper.logoImage(), width: 79, height: 38)
        vc.navigationItem.leftBarButtonItems = [menu, fixedSpace, logo]
    }
    
    private func barItem(toViewController vc: UIViewController, withSelector selector: Selector, withImage image: UIImage, width: Int = 30, height: Int = 30) -> UIBarButtonItem {
        let totalView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        button1.setImage(image, for: .normal)
        button1.addTarget(vc, action: selector, for: .touchUpInside)
        totalView.addSubview(button1)
        let barButton = UIBarButtonItem(customView: totalView)
        return barButton
    }
}

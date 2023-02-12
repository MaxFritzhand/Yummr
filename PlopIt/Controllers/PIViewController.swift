//
//  PIViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

class PIViewController: UIViewController {

    let navHelper = NavigationHelper()
    
    let haptics = UINotificationFeedbackGenerator()


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissCurrentKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissCurrentKeyboard() {
        view.endEditing(true)
    }
}

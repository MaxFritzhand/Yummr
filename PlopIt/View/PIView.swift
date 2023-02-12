//
//  PIView.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/01/2022.
//

import UIKit

class PIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addContentView()
    }
    
    func addContentView() {
        
    }

}

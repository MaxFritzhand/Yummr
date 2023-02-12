//
//  LoadingButton.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/01/2022.
//

import UIKit

class LoadingButton: PIView {

    @IBOutlet weak var loaderActivityView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    var tapHandler: (() -> ())?
    
    @IBInspectable internal var activeButtonColour: UIColor = Colours.buttonActive
    @IBInspectable internal var inactiveButtonColour: UIColor = Colours.buttonDisabled
    
    override func addContentView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupView() {
        self.actionButton.layer.cornerRadius = 8
        self.actionButton.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 8
        self.loadingView.clipsToBounds = true
        self.loadingView.alpha = 0
        updateToDisabled()
    }
    
    func updateToDisabled() {
        self.actionButton.backgroundColor = Colours.buttonDisabled
        self.loadingView.backgroundColor = Colours.buttonDisabled
        self.actionButton.isEnabled = false
        self.actionButton.setTitleColor(.white, for: .normal)
    }
    
    func updateToEnabled() {
        self.actionButton.backgroundColor = Colours.buttonActive
        self.loadingView.backgroundColor = Colours.buttonActive
        self.actionButton.isEnabled = true
        self.actionButton.setTitleColor(.white, for: .normal)

    }
    
    func updateForPublish() {
        self.actionButton.backgroundColor = Style.publishGreen
        self.loadingView.backgroundColor = Style.publishGreen
        self.actionButton.isEnabled = true
        self.actionButton.setTitleColor(.white, for: .normal)
    }
    
    func updateForDelete() {
        self.actionButton.backgroundColor = Style.deleteRed
        self.loadingView.backgroundColor = Style.deleteRed
        self.actionButton.isEnabled = true
        self.actionButton.setTitleColor(.white, for: .normal)
    }
    
    func setup(withTapHandler tapHandler: (() -> ())?, withTitle title: String) {
        self.tapHandler = tapHandler
        setupView()
        self.actionButton.setTitle(title, for: .normal)
    }
    
    func setTitle(to title: String) {
        self.actionButton.setTitle(title, for: .normal)
    }
    
    func updateColor(to color: UIColor) {
        self.actionButton.backgroundColor = color
        self.loadingView.backgroundColor = color
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 1
        }) { (completed) in
            self.loaderActivityView.startAnimating()
        }
    }
    
    func stopLoading(withCompletion completion: (() -> ())? = nil) {
        self.loaderActivityView.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 0
        }) { (completed) in
            if completion != nil {
                completion!()
            }
        }
    }
    
    @IBAction func actionTapped() {
        if tapHandler != nil {
            startLoading()
            tapHandler!()
        }
    }
}

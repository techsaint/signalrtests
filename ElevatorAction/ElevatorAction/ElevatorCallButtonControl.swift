//
//  ElevatorCallButtonControl.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/25/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

@IBDesignable class ElevatorCallButtonControl: UIStackView {

    //MARK: Properties
    private var upCall = UIButton()
    private var downCall = UIButton()
    var upCalled = false{
        didSet {
            updateButtonSelectionStates()
        }
    }
    var downCalled = false{
        didSet {
            updateButtonSelectionStates()
        }
    }

    
    @IBInspectable var callButtonSize: CGSize = CGSize(width: 20.0, height: 20.0)
    //MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder){
        super.init(coder: coder)
        setupButtons()
        
    }
    
    //MARK: Private Methods
    private func setupButtons(){
        let bundle = Bundle(for: type(of: self))
        let upCaret = UIImage(named: "upCaret", in: bundle, compatibleWith: self.traitCollection)
        let downCaret = UIImage(named:"downCaret", in: bundle, compatibleWith: self.traitCollection)
        
        self.upCall.translatesAutoresizingMaskIntoConstraints = false
        self.upCall.heightAnchor.constraint(equalToConstant: callButtonSize.height).isActive = true
        self.upCall.widthAnchor.constraint(equalToConstant: callButtonSize.width).isActive = true
        self.upCall.setImage(nil, for: .normal)
        self.upCall.setImage(upCaret, for: .selected)
        
        self.downCall.translatesAutoresizingMaskIntoConstraints = false
        self.downCall.heightAnchor.constraint(equalToConstant: callButtonSize.height).isActive = true
        self.downCall.widthAnchor.constraint(equalToConstant: callButtonSize.width).isActive = true
        self.downCall.setImage(nil, for: .normal)
        self.downCall.setImage(downCaret, for: .selected)
        addArrangedSubview(self.upCall)
        addArrangedSubview(self.downCall)
        updateButtonSelectionStates()
    }
    private func updateButtonSelectionStates(){
            upCall.isSelected = upCalled
            downCall.isSelected = downCalled
    }
}

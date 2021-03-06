//
//  FirstScreen.swift
//  SVPMap
//
//  Created by Jiri Rychlovsky on 11.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout
import ios_core

/*
 
 Class which fills a chapter with a blank page at the start
 
 */
class FirstScreen: UIView {
    var shouldSetupConstraints = true
    var label: UILabel!
    
    public init(question: QuestionSlide){
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func updateConstraints() {
        if(shouldSetupConstraints) {
            if let tw = label{
                tw.autoCenterInSuperview()
            }
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    
}

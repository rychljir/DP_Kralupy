//
//  CustomView.swift
//  SVPMap
//
//  Created by Jiri Rychlovsky on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout
import ios_core

/*
 
 Class which fills a chapter on places where should be custom task
 
*/
class CustomView: UIView {
    var shouldSetupConstraints = true
    var label: UILabel!
    
    public init(question: QuestionSlide){
        super.init(frame: CGRect.zero)
        
            if let name = question.name{
                label = UILabel(frame: CGRect.zero)
                label.text = "Custom slide: \(name)"
                label.textColor = UIColor.white
                label.backgroundColor = nil
                label.font = UIFont.systemFont(ofSize: CGFloat(25))
                self.addSubview(label)
            
        }
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

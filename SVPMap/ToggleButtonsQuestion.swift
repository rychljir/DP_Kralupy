//
//  ToggleButtonsQuestion.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

class ToggleButtonsQuestion: UIView {
    var question: Question?
    
    var toggles = [ToggleWithLabel]()
    
    var shouldSetupConstraints = true
    
    public init(question: Question){
        super.init(frame: CGRect.zero)
        self.question = question
        
        self.question!.answers.removeAll()
        for choice in self.question!.variants{
            let toggle = ToggleWithLabel.instanceFromNib()
            toggle.bringSubview(toFront: self)
            toggle.isUserInteractionEnabled = true
            
            let answer : [String] = choice.components(separatedBy: ";")
            (toggle as! ToggleWithLabel).setLabel(text: answer[0])
            if(Int(answer[1])! == 0){
                self.question!.answers.append("true")
            }else{
                self.question!.answers.append("false")
            }
            self.addSubview(toggle)
            toggles.append(toggle as! ToggleWithLabel)
        }
        
        self.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func updateConstraints() {
        if(shouldSetupConstraints) {
            if(self.subviews.count>0){
                self.subviews[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(50))
                self.subviews[0].autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
                self.subviews[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(50))
                self.subviews[0].autoSetDimension(.height, toSize: CGFloat(45))
            }
            
            for i in 1 ..< self.subviews.count{
                    self.subviews[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(50))
                    self.subviews[i].autoPinEdge(.top, to: .bottom, of: self.subviews[i-1], withOffset: CGFloat(20))
                    self.subviews[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(50))
                    self.subviews[i].autoSetDimension(.height, toSize: CGFloat(45))
            }
            
            self.autoPinEdge(.bottom, to: .bottom, of: self.subviews[self.subviews.count-1])
        
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    public func completeTask(){
        for i in 0 ..< toggles.count{
            toggles[i].isUserInteractionEnabled = false
            let filledAnswer = toggles[i].isChecked
            let correctAnswer: Int
            if (question!.answers[i] == "true"){
                correctAnswer = 0
            }else{
                correctAnswer = 1
            }
            if correctAnswer != filledAnswer{
                let evalImg = UIImageView(frame: CGRect(x: toggles[i].frame.maxX-30, y: toggles[i].center.y-25, width: CGFloat(50), height: CGFloat(50)))
                evalImg.contentMode = UIViewContentMode.scaleAspectFit
                evalImg.image = UIImage(named: "vyhodnoceni_spatne")
                self.addSubview(evalImg)
            }else{
                let evalImg = UIImageView(frame: CGRect(x: toggles[i].frame.maxX-30, y: toggles[i].center.y-25, width: CGFloat(70), height: CGFloat(70)))
                evalImg.contentMode = UIViewContentMode.scaleAspectFit
                evalImg.image = UIImage(named: "vyhodnoceni_spravne")
                self.addSubview(evalImg)
            }
        }
    }
    
    public func evaluate() -> Bool{
        var correct = true
        for i in 0 ..< question!.answers.count{
            let filledAnswer = toggles[i].isChecked
            let correctAnswer: Int
            if (question!.answers[i] == "true"){
                correctAnswer = 0
            }else{
                correctAnswer = 1
            }
            if correctAnswer != filledAnswer{
                correct = false
            }
        }
        return correct
    }

}

//
//  RadioButtonsGroup.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout
import DLRadioButton

class SingleChoiceQuestion: UIView {
    
    var radios = [DLRadioButton]()
    var question: Question!
    
    var shouldSetupConstraints = true
    
    public init(question: Question){
        super.init(frame: CGRect.zero)
        self.question = question
        for choice in question.variants {
            let radio = createRadioButton(frame: CGRect.zero, title: choice, color: UIColor.white)
            self.addSubview(radio)
            radios.append(radio)
            radio.isUserInteractionEnabled = true
            radio.bringSubview(toFront: self)
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
                self.subviews[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                self.subviews[0].autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
                self.subviews[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(50))
            }
            
            for i in 1 ..< self.subviews.count{

                    self.subviews[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                    self.subviews[i].autoPinEdge(.top, to: .bottom, of: self.subviews[i-1], withOffset: CGFloat(20))
                    self.subviews[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(50))
                
            }
            self.autoPinEdge(.bottom, to: .bottom, of: self.subviews[self.subviews.count-1])
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    
    public func completeTask(){
        var correctIndex = -1
        for i in 0 ..< question.answers.count{
            if question.answers[i] == "true"{
                correctIndex = i
                break
            }
        }
        
        var answeredIndex = -1
        for i in 0 ..< radios.count{
            if radios[i].isSelected{
                answeredIndex = i
                break
            }
        }
        
        if answeredIndex == correctIndex{
            let evalImg = UIImageView(frame: CGRect(x: radios[correctIndex].frame.maxX-30, y: radios[correctIndex].center.y-25, width: CGFloat(50), height: CGFloat(50)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_spravne")
            self.addSubview(evalImg)
        }else{
            if(answeredIndex >= 0){
                let evalImg = UIImageView(frame: CGRect(x: radios[answeredIndex].frame.maxX-30, y: radios[answeredIndex].center.y-25, width: CGFloat(50), height: CGFloat(50)))
                evalImg.contentMode = UIViewContentMode.scaleAspectFit
                evalImg.image = UIImage(named: "vyhodnoceni_spatne")
                self.addSubview(evalImg)
            }
            let evalImg = UIImageView(frame: CGRect(x: radios[correctIndex].frame.maxX-30, y: radios[correctIndex].center.y-25, width: CGFloat(70), height: CGFloat(70)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_shouldbe")
            self.addSubview(evalImg)
        }
        
        for radio in radios{
            radio.isUserInteractionEnabled = false
        }
    }
    
    public func evaluate() -> Bool{
        var correct = true
        for i in 0 ..< question.answers.count{
            let filledAnswer = radios[i].isSelected
            if Bool(question.answers[i]) != filledAnswer{
                correct = false
            }
        }
        return correct
    }
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 25)
        radioButton.setTitle(title, for: .normal)
        radioButton.setTitleColor(color, for: .normal)
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.addTarget(self, action: #selector(SingleChoiceQuestion.radioClickEvent(radioButton:)), for: UIControlEvents.touchUpInside)
        return radioButton
    }
    
    @IBAction private func radioClickEvent(radioButton : DLRadioButton) {
        for i in 0 ..< radios.count{
            if(radios[i] == radioButton){
                radios[i].isSelected = true
            }else{
                radios[i].isSelected = false
            }
        }
    }
}

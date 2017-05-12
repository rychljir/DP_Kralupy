//
//  MultichoiceQuestion.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

class MultichoiceQuestion: UIView {

    var maxTries = 1
    var checkboxes = [Checkbox]()
    
    var question: Question!
    
    var shouldSetupConstraints = true
    
    public init(question: Question){
        super.init(frame: CGRect.zero)
        self.question = question
        
        for choice in question.variants {
            let checkbox = Checkbox(frame: CGRect.zero)
            checkbox.setTitle(choice, for: .normal)
            checkbox.titleLabel!.font = UIFont.systemFont(ofSize: CGFloat(25))
            checkbox.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            self.addSubview(checkbox)
            checkboxes.append(checkbox)
            checkbox.isUserInteractionEnabled = true
            checkbox.bringSubview(toFront: self)
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
        for i in 0 ..< question.answers.count{
            let filledAnswer = checkboxes[i].isChecked
            if Bool(question.answers[i]) != filledAnswer{
                let evalImg = UIImageView(frame: CGRect(x: checkboxes[i].frame.maxX-30, y: checkboxes[i].center.y-25, width: CGFloat(50), height: CGFloat(50)))
                evalImg.contentMode = UIViewContentMode.scaleAspectFit
                evalImg.image = UIImage(named: "vyhodnoceni_spatne")
                self.addSubview(evalImg)
            }else{
                let evalImg = UIImageView(frame: CGRect(x: checkboxes[i].frame.maxX-30, y: checkboxes[i].center.y-25, width: CGFloat(70), height: CGFloat(70)))
                evalImg.contentMode = UIViewContentMode.scaleAspectFit
                evalImg.image = UIImage(named: "vyhodnoceni_spravne")
                self.addSubview(evalImg)
            }
        }
    }
    
    public func evaluate() -> Bool{
        var correct = true
        for i in 0 ..< question.answers.count{
            let filledAnswer = checkboxes[i].isChecked
            if Bool(question.answers[i]) != filledAnswer{
                correct = false
            }
        }
        return correct
    }
}

//
//  FilltextQuestion.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

class FilltextQuestion: UIView, UITextFieldDelegate  {
    var question: Question!
    
    var shouldSetupConstraints = true
    
    var textfield: UITextField!
    
    public init(question: Question){
        super.init(frame: CGRect.zero)
        self.question = question
        
        textfield = UITextField(frame: CGRect.zero)
        textfield.placeholder = "Vložte odpovēd"
        textfield.font = UIFont.systemFont(ofSize: 25)
        textfield.borderStyle = UITextBorderStyle.roundedRect
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.continue
        textfield.clearButtonMode = UITextFieldViewMode.whileEditing
        textfield.textAlignment = .center
        textfield.isUserInteractionEnabled = true
        textfield.delegate = self
        textfield.bringSubview(toFront: self)
        self.addSubview(textfield)
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
            self.subviews[0].autoSetDimension(.width, toSize: CGFloat(250))
            self.subviews[0].autoAlignAxis(.vertical, toSameAxisOf: self)
            self.subviews[0].autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
            
            self.autoPinEdge(.bottom, to: .bottom, of: self.subviews[0], withOffset: CGFloat(100))
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    public func completeTask(){
        textfield.isUserInteractionEnabled = false
        if(evaluate()){
            let evalImg = UIImageView(frame: CGRect(x: textfield.frame.maxX-30, y: textfield.center.y-50, width: CGFloat(100), height: CGFloat(100)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_spravne")
            self.addSubview(evalImg)
        }else{
            let evalImg = UIImageView(frame: CGRect(x: textfield.frame.maxX-30, y: textfield.center.y-50, width: CGFloat(100), height: CGFloat(100)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_spatne")
            self.addSubview(evalImg)
            let correctAnswer = UILabel(frame: CGRect(x: textfield.center.x-75, y: textfield.frame.maxY+20, width: CGFloat(150), height: CGFloat(50)))
            correctAnswer.text = question.variants[0]
            correctAnswer.textColor = UIColor.red
            correctAnswer.font = UIFont.systemFont(ofSize: CGFloat(35))
            correctAnswer.textAlignment = NSTextAlignment.center
            self.addSubview(correctAnswer)
        }
    }
    
    public func evaluate() -> Bool{
        if(textfield.text?.lowercased() != question.variants[0].lowercased()){
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

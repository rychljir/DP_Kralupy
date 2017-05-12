//
//  NumberQuestion.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

class NumberQuestion: UIView, UITextFieldDelegate {
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
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.returnKeyType = UIReturnKeyType.continue
        textfield.clearButtonMode = UITextFieldViewMode.whileEditing
        textfield.textAlignment = .center
        textfield.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
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
            let possibleRange = getAnswer(unformattedString: question.variants[0])
            correctAnswer.text = possibleRange.correct
            correctAnswer.textColor = UIColor.red
            correctAnswer.font = UIFont.systemFont(ofSize: CGFloat(35))
            correctAnswer.textAlignment = NSTextAlignment.center
            self.addSubview(correctAnswer)
        }
    }
    
    public func evaluate() -> Bool{
        let possibleRange = getAnswer(unformattedString: question.variants[0])
        var correct = false
        if possibleRange.from == "x" && possibleRange.to == "x"{
            let selectedValue = textfield.text
            if selectedValue == possibleRange.correct{
                correct = true
            }else{
                correct = false
            }
        }else{
            let selectedValue = Double(textfield.text!)
            let from = Double(possibleRange.from!)
            let to = Double(possibleRange.to!)
            if selectedValue! >= from! && selectedValue! <= to!{
                correct = true
            }else{
                correct = false
            }
        }
        return correct
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func getAnswer(unformattedString: String) -> NumberQuestionAnswer{
        let nqAns = NumberQuestionAnswer()
        
        let elements : [String] = unformattedString.components(separatedBy: ";")
        nqAns.correct = elements[0]
        nqAns.from = elements[1]
        nqAns.to = elements[2]
        return nqAns
    }

    
    class NumberQuestionAnswer{
        var correct: String?
        var from: String?
        var to: String?
    }
}

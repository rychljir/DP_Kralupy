//
//  v_quest_img.swift
//  SVPMap
//
//  Created by Petr Mares on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout
import DLRadioButton


class v_quest_img: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var shouldSetupConstraints = true
    var parentVC: UIViewController?
    
    @IBOutlet weak var qContainer: UIView!
    
    var qAnswers = [String]()
    var qVariants = [String]()
    var qType: String?
    
    @IBOutlet weak var evalBtn: UIButton!
    var checkboxes = [Checkbox]()
    var radios = [DLRadioButton]()
    var picker: UIPickerView!
    var pickerData = [String]()
    var pickerAnswer: IntervalQuestionAnswer?
    var textfield: UITextField!
    var toggles = [SwitchWithText]()

    public func initSlide(question: QuestionSlide, callingViewController: UIViewController){
        parentVC = callingViewController
        
        if let desc = question.description{
            let title = UILabel(frame: CGRect.zero)
            title.text = desc
            title.textColor = UIColor.white
            title.font = UIFont.systemFont(ofSize: CGFloat(25))
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.numberOfLines = 0
            qContainer.addSubview(title)
        }
        
        if question.questions.count>0{
            let q = question.questions[0]
            qAnswers = q.answers
            qType = q.type
            qVariants = q.variants
            if let desc = q.description{
                let qTitle = UILabel(frame: CGRect.zero)
                qTitle.text = desc
                qTitle.textColor = UIColor.white
                qTitle.font = UIFont.systemFont(ofSize: CGFloat(25))
                qTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
                qTitle.numberOfLines = 0
                qContainer.addSubview(qTitle)
            }
            if let shuffle = q.shuffle{
                if shuffle == "true"{
                    shuffleVariants()
                }
            }
            
            if let type = qType{
                switch type {
                case "singlechoice":
                    for choice in qVariants {
                        let radio = createRadioButton(frame: CGRect.zero, title: choice, color: UIColor.white)
                        qContainer.addSubview(radio)
                        radios.append(radio)
                        radio.isUserInteractionEnabled = true
                        radio.bringSubview(toFront: self)
                    }
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                case "multichoice":
                    for choice in qVariants {
                        let checkbox = Checkbox(frame: CGRect.zero)
                        checkbox.setTitle(choice, for: .normal)
                        checkbox.titleLabel!.font = UIFont.systemFont(ofSize: CGFloat(25))
                        checkbox.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                        qContainer.addSubview(checkbox)
                        checkboxes.append(checkbox)
                        checkbox.isUserInteractionEnabled = true
                        checkbox.bringSubview(toFront: self)
                    }
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                case "intervalquestion":
                    picker = UIPickerView(frame: CGRect.zero)
                    picker.dataSource = self
                    picker.delegate = self
                    picker.isUserInteractionEnabled = true
                    picker.bringSubview(toFront: self)
                    
                    pickerData = getVariantsForPicker(unformattedString: q.variants[0])
                    
                    qContainer.addSubview(picker)
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                case "fillText":
                    textfield = UITextField(frame: CGRect.zero)
                    textfield.placeholder = "Vložte odpovēd"
                    textfield.font = UIFont.systemFont(ofSize: 25)
                    textfield.borderStyle = UITextBorderStyle.roundedRect
                    textfield.autocorrectionType = UITextAutocorrectionType.no
                    textfield.keyboardType = UIKeyboardType.default
                    textfield.returnKeyType = UIReturnKeyType.continue
                    textfield.clearButtonMode = UITextFieldViewMode.whileEditing
                    textfield.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                    textfield.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                    textfield.isUserInteractionEnabled = true
                    textfield.delegate = self
                    textfield.bringSubview(toFront: self)
                    qContainer.addSubview(textfield)
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                case "numberquestion":
                    textfield = UITextField(frame: CGRect.zero)
                    textfield.placeholder = "Vložte odpovēd"
                    textfield.font = UIFont.systemFont(ofSize: 25)
                    textfield.borderStyle = UITextBorderStyle.roundedRect
                    textfield.autocorrectionType = UITextAutocorrectionType.no
                    textfield.keyboardType = UIKeyboardType.decimalPad
                    textfield.returnKeyType = UIReturnKeyType.continue
                    textfield.clearButtonMode = UITextFieldViewMode.whileEditing
                    textfield.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                    textfield.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                    textfield.isUserInteractionEnabled = true
                    textfield.delegate = self
                    textfield.bringSubview(toFront: self)
                    qContainer.addSubview(textfield)
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                case "togglebuttonsgrid":
                    qAnswers.removeAll()
                    for choice in qVariants{
                        let toggle = SwitchWithText.instanceFromNib()
                        toggle.bringSubview(toFront: self)
                        toggle.isUserInteractionEnabled = true
                        
                        let answer : [String] = choice.components(separatedBy: ";")
                        (toggle as! SwitchWithText).setLabel(text: answer[0])
                        if(Int(answer[1])! == 0){
                            qAnswers.append("true")
                        }else{
                            qAnswers.append("false")
                        }
                        qContainer.addSubview(toggle)
                        toggles.append(toggle as! SwitchWithText)
                    }
                    qContainer.bringSubview(toFront: self)
                    qContainer.isUserInteractionEnabled = true
                    break
                default:
                    break
                }
            }
            if let val = q.validate{
                if val == "true"{
                    evalBtn!.addTarget(self, action: #selector(v_quest_img.evaluateTask), for: UIControlEvents.touchUpInside)
                }else{
                    evalBtn!.isHidden = true
                }
            }
        }else{
            evalBtn!.isHidden = true
        }
        if question.images.count>0{
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.image = UIImage(named: question.images[0])
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            qContainer.addSubview(imageView)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = pickerData[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 35.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        label?.textColor = UIColor.white
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func getVariantsForPicker(unformattedString: String) -> [String]{
            let elements : [String] = unformattedString.components(separatedBy: ";")
        pickerAnswer = IntervalQuestionAnswer()
        pickerAnswer?.correct = elements[0]
        pickerAnswer?.correctFrom = elements[1]
        pickerAnswer?.correctTo = elements[2]
        pickerAnswer?.from = elements[3]
        pickerAnswer?.to = elements[4]
        pickerAnswer?.step = elements[5]
        
        let from:Int = Int((pickerAnswer?.from)!)!
        let to:Int = Int((pickerAnswer?.to)!)!
        let step:Int = Int((pickerAnswer?.step)!)!
        
        var result = [String]()
        for i in stride(from: from, to: to+1, by: step) {
                result.append(String(i))
        }
        
        return result
    }
    
    func getAnswerForNumberQuestion(unformattedString: String) -> NumberQuestionAnswer{
        let nqAns = NumberQuestionAnswer()
        
        let elements : [String] = unformattedString.components(separatedBy: ";")
        nqAns.correct = elements[0]
        nqAns.from = elements[1]
        nqAns.to = elements[2]
        return nqAns
    }
    
    func shuffleVariants(){
        var shuffler = [Int]()
        for i in 0 ..< qVariants.count{
            shuffler.append(i)
        }
        
        shuffler.shuffle()
        
        var tempVariants = [String]()
        var tempAnswers = [String]()
        for i in 0 ..< shuffler.count{
            tempVariants.append(qVariants[shuffler[i]])
            tempAnswers.append(qAnswers[shuffler[i]])
        }
        qVariants = tempVariants
        qAnswers = tempAnswers
        
    }
    
    override public func updateConstraints() {
        if(shouldSetupConstraints) {
            if(qContainer.subviews.count>0){
                qContainer.subviews[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                qContainer.subviews[0].autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
                qContainer.subviews[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
            }
            
            for i in 1 ..< qContainer.subviews.count{
                if let subview = qContainer.subviews[i] as? SwitchWithText {
                    subview.autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                    subview.autoPinEdge(.top, to: .bottom, of: qContainer.subviews[i-1], withOffset: CGFloat(20))
                    subview.autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                    subview.autoSetDimension(.height, toSize: CGFloat(45))
                }
                else {
                    qContainer.subviews[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                    qContainer.subviews[i].autoPinEdge(.top, to: .bottom, of: qContainer.subviews[i-1], withOffset: CGFloat(20))
                    qContainer.subviews[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                }

            }
        
            qContainer.autoPinEdge(.bottom, to: .bottom, of: qContainer.subviews[qContainer.subviews.count-1])
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    private func taskDone(){
        evalBtn!.isEnabled = false
        for i in 0 ..< radios.count{
            radios[i].isUserInteractionEnabled = false
            if(Bool(qAnswers[i]))!{
                radios[i].isSelected = true
            }else{
                radios[i].isSelected = false
            }
        }
        for i in 0 ..< checkboxes.count{
            checkboxes[i].isUserInteractionEnabled = false
            if(Bool(qAnswers[i]))!{
                checkboxes[i].isChecked = true
            }else{
                checkboxes[i].isChecked = false
            }
        }
        if let p = picker{
            p.isUserInteractionEnabled = false
        }
        if let tf = textfield{
            tf.isUserInteractionEnabled = false
        }
        for i in 0 ..< toggles.count{
            toggles[i].setEnabled(isEnabled: false)
        }
    }
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 25)
        radioButton.setTitle(title, for: .normal)
        radioButton.setTitleColor(color, for: .normal)
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.addTarget(self, action: #selector(v_quest_img.radioClickEvent(radioButton:)), for: UIControlEvents.touchUpInside)
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
    
    @IBAction private func evaluateTask(eval : UIButton) {
        switch qType! {
        case "singlechoice":
            var correct = true
            for i in 0 ..< qAnswers.count{
                let filledAnswer = radios[i].isSelected
                if Bool(qAnswers[i]) != filledAnswer{
                    correct = false
                }
            }
            if !correct{
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
        case "multichoice":
            var correct = true
            for i in 0 ..< qAnswers.count{
                let filledAnswer = checkboxes[i].isChecked
                if Bool(qAnswers[i]) != filledAnswer{
                    correct = false
                }
            }
            if !correct{
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
        case "intervalquestion":
            var correct = false
            if pickerAnswer?.correctFrom == "x" && pickerAnswer?.correctTo == "x"{
                let selectedValue = pickerData[picker.selectedRow(inComponent: 0)]
                if selectedValue == pickerAnswer?.correct{
                    correct = true
                }else{
                    correct = false
                }
            }else{
                let selectedValue = Int(pickerData[picker.selectedRow(inComponent: 0)])
                if selectedValue! >= Int((pickerAnswer?.correctFrom)!)! && selectedValue! <= Int((pickerAnswer?.correctTo)!)!{
                    correct = true
                }else{
                    correct = false
                }
            }
            if !correct{
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
            break
        case "fillText":
            if(textfield.text?.lowercased() != qVariants[0].lowercased()){
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
            break
        case "numberquestion":
            let possibleRange = getAnswerForNumberQuestion(unformattedString: qVariants[0])
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
            if !correct{
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
            break
        case "togglebuttonsgrid":
            var correct = true
            for i in 0 ..< qAnswers.count{
                let filledAnswer = toggles[i].isChecked
                if Bool(qAnswers[i]) != filledAnswer{
                    correct = false
                }
            }
            if !correct{
                parentVC?.showToast(message: "Ups, tak to se úplnē nepovedlo.")
            }else{
                parentVC?.showToast(message: "Správnē!")
                taskDone()
            }
            break
        default:
            break
        }

        
    }
}

class IntervalQuestionAnswer{
    var correct: String?
    var correctFrom: String?
    var correctTo: String?
    var from: String?
    var to: String?
    var step: String?
}

class NumberQuestionAnswer{
    var correct: String?
    var from: String?
    var to: String?
}

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}



//
//  IntervalQuestion.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

class IntervalQuestion: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var question: Question!
    
    var picker: UIPickerView!
    var pickerData = [String]()
    var pickerAnswer: IntervalQuestionAnswer?
    
    var shouldSetupConstraints = true
    
    public init(question: Question){
        super.init(frame: CGRect.zero)
        self.question = question
        
        picker = UIPickerView(frame: CGRect.zero)
        picker.dataSource = self
        picker.delegate = self
        picker.isUserInteractionEnabled = true
        picker.bringSubview(toFront: self)
        
        pickerData = getVariantsForPicker(unformattedString: question.variants[0])
        
        self.addSubview(picker)
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
            self.subviews[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(150))
            self.subviews[0].autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
            self.subviews[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(150))
            
            self.autoPinEdge(.bottom, to: .bottom, of: self.subviews[0], withOffset: CGFloat(100))
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    public func completeTask(){
        picker!.isUserInteractionEnabled = false
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
        if(correct){
            let evalImg = UIImageView(frame: CGRect(x: picker.frame.maxX-30, y: picker.center.y-25, width: CGFloat(100), height: CGFloat(100)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_spravne")
            self.addSubview(evalImg)
            let correctNumber = UILabel(frame: CGRect(x: picker.center.x-75, y: picker.frame.maxY+20, width: CGFloat(150), height: CGFloat(50)))
            correctNumber.text = pickerAnswer?.correct
            correctNumber.textColor = UIColor.green
            correctNumber.font = UIFont.systemFont(ofSize: CGFloat(35))
            correctNumber.textAlignment = NSTextAlignment.center
            self.addSubview(correctNumber)
        }else{
            let evalImg = UIImageView(frame: CGRect(x: picker.frame.maxX-30, y: picker.center.y-25, width: CGFloat(100), height: CGFloat(100)))
            evalImg.contentMode = UIViewContentMode.scaleAspectFit
            evalImg.image = UIImage(named: "vyhodnoceni_spatne")
            self.addSubview(evalImg)
            let correctNumber = UILabel(frame: CGRect(x: picker.center.x-75, y: picker.frame.maxY+20, width: CGFloat(150), height: CGFloat(50)))
            correctNumber.text = pickerAnswer?.correct
            correctNumber.textColor = UIColor.red
            correctNumber.font = UIFont.systemFont(ofSize: CGFloat(35))
            correctNumber.textAlignment = NSTextAlignment.center
            self.addSubview(correctNumber)
        }
    }
    
    public func evaluate() -> Bool{
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
        return correct
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
    
    class IntervalQuestionAnswer{
        var correct: String?
        var correctFrom: String?
        var correctTo: String?
        var from: String?
        var to: String?
        var step: String?
    }

}

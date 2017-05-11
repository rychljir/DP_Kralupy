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


class v_quest_img: UIView {
    var shouldSetupConstraints = true
    var parentVC: UIViewController?
    
    @IBOutlet weak var qContainer: UIView!
    
    var qAnswers = [String]()
    var qVariants = [String]()
    var qType: String?
    
    @IBOutlet weak var evalBtn: UIButton!
    var checkboxes = [Checkbox]()
    var radios = [DLRadioButton]()

    
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
                qContainer.subviews[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                qContainer.subviews[i].autoPinEdge(.top, to: .bottom, of: qContainer.subviews[i-1], withOffset: CGFloat(20))
                qContainer.subviews[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
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
        default:
            break
        }

        
    }
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



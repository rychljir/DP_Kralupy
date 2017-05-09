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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var qContainer: UIView!
    
    var qAnswers = [String]()
    var qVariants = [String]()
    var qTitle: UILabel!
    var qType: String?
    
    var checkboxes = [CheckBox]()
    var radios = [DLRadioButton]()
    var evalBtn: UIButton?
    
    public func initSlide(question: QuestionSlide, callingViewController: UIViewController){
        parentVC = callingViewController
        if let desc = question.description{
            textView.text = desc
        }else{
            textView.isHidden = true
        }
        if question.images.count>0{
            imageView.image = UIImage(named: question.images[0])
        }else{
            imageView.isHidden = true
        }
        
        if question.questions.count>0{
            let q = question.questions[0]
            qAnswers = q.answers
            qType = q.type
            qVariants = q.variants
            if let desc = q.description{
                qTitle = UILabel(frame: CGRect.zero)
                qTitle.text = desc
                qTitle.textColor = UIColor.white
                qTitle.font = UIFont.systemFont(ofSize: CGFloat(25))
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
                        let checkbox = CheckBox(frame: CGRect.zero)
                        checkbox.titleLabel?.text = choice
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
                    evalBtn = UIButton(frame: CGRect.zero)
                    evalBtn!.setImage(UIImage(named: "vyhodnotit_normal"), for: .normal)
                    evalBtn!.setImage(UIImage(named: "vyhodnotit_pressed"), for: .highlighted)
                    evalBtn!.setImage(UIImage(named: "vyhodnotit_disabled"), for: .disabled)
                    qContainer.superview!.addSubview(evalBtn!)
                    evalBtn!.addTarget(self, action: #selector(v_quest_img.evaluateTask), for: UIControlEvents.touchUpInside)
                }
            }
        }else{
            qContainer.isHidden = true
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
            
            if let tw = qTitle{
                tw.autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                tw.autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(0))
                tw.autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                //tw.autoPinEdge(toSuperviewEdge: .bottom, withInset: CGFloat(20))
            }
            
            if radios.count>0{
                radios[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                radios[0].autoPinEdge(.top, to: .bottom, of: qTitle, withOffset: CGFloat(30))
                radios[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                //radios[0].autoPinEdge(toSuperviewEdge: .bottom, withInset: CGFloat(20))
                
                for i in 1 ..< radios.count{
                    radios[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                    radios[i].autoPinEdge(.top, to: .bottom, of: radios[i-1], withOffset: CGFloat(30))
                    radios[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                }
                qContainer.autoPinEdge(.top, to: .top, of: qTitle)
                qContainer.autoPinEdge(.bottom, to: .bottom, of: radios[radios.count-1])
            }
            
            if checkboxes.count>0{
                checkboxes[0].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                checkboxes[0].autoPinEdge(.top, to: .bottom, of: qTitle, withOffset: CGFloat(30))
                //checkboxes[0].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                
                for i in 1 ..< checkboxes.count{
                    checkboxes[i].autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(0))
                    checkboxes[i].autoPinEdge(.top, to: .bottom, of: checkboxes[i-1], withOffset: CGFloat(30))
                   // checkboxes[i].autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(0))
                }
                qContainer.autoPinEdge(.top, to: .top, of: qTitle)
                qContainer.autoPinEdge(.bottom, to: .bottom, of: checkboxes[checkboxes.count-1])
            }
            
            if let eval = evalBtn{
                eval.autoPinEdge(toSuperviewEdge: .bottom, withInset: CGFloat(10))
                eval.autoAlignAxis(toSuperviewAxis: .vertical)
            }
            
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

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkbox_checked")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
                
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

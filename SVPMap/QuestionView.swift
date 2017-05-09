//
//  SlideView.swift
//  SVPMap
//
//  Created by Petr Mares on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import PureLayout

public class QuestionView: UIView {
    var shouldSetupConstraints = true
    var scroll: UIScrollView!
    var textView: UITextView!
    var imageView: UIImageView?
    var type: String?
    
    public init(question: QuestionSlide){
        super.init(frame: CGRect.zero)
        
        if(question.layout == "v_quest_img"){
            if let desc = question.description{
                textView = UITextView(frame: CGRect.zero)
                textView.text = desc
                textView.textColor = UIColor.white
                textView.backgroundColor = nil
                textView.font = UIFont.systemFont(ofSize: CGFloat(25))
                textView.textAlignment = NSTextAlignment.justified
                self.addSubview(textView)
            }
            if question.images.count>0{
                    let imageView = UIImageView(frame: CGRect.zero)
                    imageView.image = UIImage(named: question.images[0])
                    self.addSubview(imageView)
                }
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
            
            if let tw = textView{
                tw.autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(40))
                tw.autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(20))
                tw.autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(40))
                tw.autoPinEdge(toSuperviewEdge: .bottom, withInset: CGFloat(20))
            }
            
            if let img = imageView {
                img.autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat(40))
                img.autoPinEdge(toSuperviewEdge: .right, withInset: CGFloat(40))
                img.autoPinEdge(toSuperviewEdge: .bottom, withInset: CGFloat(20))
                if let tw = textView{
                  img.autoPinEdge(.top, to: .bottom, of: tw)
                }else{
                   img.autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(20))
                }
            }
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
}

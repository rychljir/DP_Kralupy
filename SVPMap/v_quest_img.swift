//
//  v_quest_img.swift
//  SVPMap
//
//  Created by Petr Mares on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

class v_quest_img: UIView {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    public func initSlide(question: QuestionSlide){
        if let desc = question.description{
            textView.text = desc
        }else{
            textView.text = ""
        }
        if question.images.count>0{
            imageView.image = UIImage(named: question.images[0])
        }else{
            imageView.image = nil
        }
    }

}


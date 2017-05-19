//
//  SlideFactory.swift
//  SVPMap
//
//  Created by Jiri Rychlovsky on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import ios_core

/*
 
 Class which creates an array of UIView based on QuestionSlide
 
 */
class SlideFactory: UIViewController {

    public func prepareSlides(questionSet: [QuestionSlide], maxTries: Int, callingViewController: UIViewController) -> [UIView]{
        var result = [UIView]()
        for q in questionSet{
            if(q.type == "custom"){
                let customView = CustomView(question: q)
                result.append(customView)
            }
            if q.name == "firstScreen"{
                let first = FirstScreen(question: q)
                result.append(first)
            }
            if(q.layout == "v_quest_img"){
                let questView: v_quest_img = Bundle(for: v_quest_img.self).loadNibNamed("v_quest_img", owner: self, options: nil)?.first as! v_quest_img
                questView.initSlide(question: q, maximumTries: maxTries, callingViewController: callingViewController)
                result.append(questView)
            }
        }
        return result
    }
    
}

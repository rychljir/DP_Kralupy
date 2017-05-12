//
//  QuestionSlide.swift
//  SVPMap
//
//  Created by Petr Mares on 12.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import Foundation

public class QuestionSlide{
    var title: String?
    var description: String?
    var name: String?
    var type: String?
    var layout: String?
    var timelimit: String?
    var answers = [String]()
    var texts = [String]()
    var questions = [Question]()
    var images = [String]()
    var video: String?
}

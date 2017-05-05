//
//  QuestionParser.swift
//  SVPMap
//
//  Created by Petr Mares on 05.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import Foundation
import AEXML

public class QuestionParser{
    var xmlDoc: AEXMLDocument?
    var tasks = [Task]()

    public init(xmlDocument: AEXMLDocument){
        xmlDoc = xmlDocument
        parseXML()
    }
    
    
    func parseXML(){
        if let tasksXML = xmlDoc?.root.children[0].all{
            for task in tasksXML{
                var taskXML = Task()
                if let latitude = task["location"]["latitude"].value{
                    if let longitude = task["location"]["longitude"].value{
                        let location = [Double(latitude),Double(longitude)]
                        taskXML.location = location as! [Double]
                        print(latitude + " ; " + longitude)
                    }
                }
                if let name = task.attributes["name"]{
                    taskXML.name = name
                }
                if let qSlidesXML = task["questionslide"].all{
                    for qSlideXML in qSlidesXML{
                        let qSlide = QuestionSlide()
                        if let name = qSlideXML.attributes["name"]{
                            qSlide.name = name
                        }
                        if let title = qSlideXML.attributes["title"]{
                            qSlide.title = title
                        }
                        if let header = qSlideXML["header"].value{
                            qSlide.header = header
                        }
                        if let desc = qSlideXML["description"].value{
                            qSlide.description = desc
                        }
                        //  if let questions = task["questionslide"]["questions"]["question"].all{
                        if let questions = qSlideXML["questions"]["question"].all{
                            for question in questions{
                                let q = Question()
                                if let type = question.attributes["type"]{
                                    q.type = type
                                }
                                if let shuffle = question.attributes["shuffle"]{
                                    q.shuffle = shuffle
                                }
                                if let description = question["description"].value{
                                    q.description = description
                                }
                                if let variantsXML = question["variant"].all{
                                    for variantXML in variantsXML{
                                        if let variant = variantXML.value{
                                          q.variants.append(variant)
                                        }
                                    }
                                }
                                qSlide.questions.append(q)
                            }
                        }
                        
                        taskXML.slides.append(qSlide)
                    }
                }
                tasks.append(taskXML)
            }
        }
    }
    
    public func getTasks() -> [Task]{
        return tasks
    }

    
}

public class Task{
    var location = [Double]()
    var slides = [QuestionSlide]()
    var name: String?
}

public class QuestionSlide{
    var header: String?
    var title: String?
    var description: String?
    var name: String?
    var answers = [String]()
    var texts = [String]()
    var questions = [Question]()
}

public class Question{
    var type: String?
    var shuffle: String?
    var description: String?
    var variants = [String]()
    var answers = [String]()
}

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
    var maxTries = 1
    
    public init(xmlDocument: AEXMLDocument){
        xmlDoc = xmlDocument
        parseXML()
    }
    
    
    func parseXML(){
        if let tries = xmlDoc?.root.attributes["maxTries"]{
            maxTries = Int(tries)!
        }
        if let tasksXML = xmlDoc?.root.children[0].all{
            for task in tasksXML{
                let taskXML = Task()
                if let latitude = task["location"]["latitude"].value{
                    if let longitude = task["location"]["longitude"].value{
                        if let lat = Double(latitude){
                            if let long = Double(longitude){
                                let location = [lat,long]
                                taskXML.location = location
                                //print("\(lat) ; \(long)")
                            }
                        }
                        
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
                        if let type = qSlideXML.attributes["type"]{
                            qSlide.type = type
                        }
                        if let layout = qSlideXML.attributes["layout"]{
                            qSlide.layout = layout
                        }
                        if let title = qSlideXML.attributes["title"]{
                            qSlide.title = title
                        }
                        if let timelimit = qSlideXML.attributes["timelimit"]{
                            qSlide.timelimit = timelimit
                        }
                        if let header = qSlideXML["header"].value{
                            taskXML.header = header
                        }
                        if let video = qSlideXML["video"].value{
                            qSlide.video = video
                        }
                        if let image = qSlideXML["images"].value{
                            qSlide.images.append(image)
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
                                if let validate = question.attributes["validate"]{
                                    q.validate = validate
                                }
                                if let description = question["description"].value{
                                    q.description = description
                                }
                                if let variantsXML = question["variant"].all{
                                    for variantXML in variantsXML{
                                        if let variant = variantXML.value{
                                            q.variants.append(variant)
                                        }
                                        if let valid = variantXML.attributes["valid"]{
                                            q.answers.append(valid)
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
    
    public func getTries() -> Int{
        return maxTries
    }
    
    
}


//
//  ChapterViewController.swift
//  SVPMap
//
//  Created by Petr Mares on 07.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

class ChapterViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var slideScrollView: UIScrollView!
    @IBOutlet weak var pagerIndex: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var pagerCounter: UILabel!
    @IBOutlet weak var taskNumber: UILabel!
    

    
    let factory = SlideFactory()
    
    
    var slides = [UIView]()
    var tasks = [Task]()
    var index = 0
    var maxTries = 0
    
    var backImage: UIImage?
    var titleText: String?
    var slideCounter: String?
    var taskIndex: String?
    
    
    @IBAction func backToMap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.present(vc, animated: true, completion:nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        slideScrollView.delegate = self
        setupSlideScrollView(slides: slides)
        updateChapter()
    }

    func setupSlideScrollView(slides:[UIView]){
        slideScrollView.frame = CGRect(x: slideScrollView.frame.minX, y: slideScrollView.frame.minY, width: self.view.frame.width, height: slideScrollView.frame.height)
        slideScrollView.contentSize = CGSize(width: slideScrollView.frame.width*CGFloat(slides.count), height: slideScrollView.frame.height)
        slideScrollView.isPagingEnabled = true
        slideScrollView.showsVerticalScrollIndicator = false
        slideScrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< slides.count{
            slides[i].frame = CGRect(x: slideScrollView.frame.width*CGFloat(i), y: 0, width: slideScrollView.frame.width, height: slideScrollView.frame.height)
            slideScrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pagerIndex.text = String(Int(pageIndex+1))
    }
    
    func setIndex(index: Int){
        self.index = index
    }
    
    func setTasks(tasks: [Task]){
        self.tasks = tasks
    }
    
    func setMaxTries(max: Int){
        maxTries = max
    }
    
    func setupChapter(){
        switch index {
        case (-1): break
            
        default:
            backImage = UIImage(named: "bg_task01")
            titleText = tasks[index].header
            slideCounter = "| \(slides.count)"
            taskIndex = String(index+1)
        }
    }
    
    func updateChapter(){
        switch index {
        case (-1): break
            
        default:
            backgroundImage.image = backImage
            taskTitle.text = titleText
            pagerCounter.text = slideCounter
            taskNumber.text = taskIndex
        }
    }
    
    func prepareSlides(){
        switch index {
        case (-1): break
            
        default:
            slides = factory.prepareSlides(questionSet: tasks[index].slides, callingViewController: self)
        }
    }


}

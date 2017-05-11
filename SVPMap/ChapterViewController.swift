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
    
    let chapterBackground = ["bg_task01", "bg_task02", "bg_task03", "bg_task04", "bg_task05", "bg_task06", "bg_task07", "bg_task08", "bg_task09",
                             "bg_task10", "bg_task11", "bg_task12", "bg_task13", "bg_task14", "bg_task15", "bg_task16", "bg_task17"]
    
    var slides = [UIView]()
    var tasks = [Task]()
    var index = 0
    var maxTries = 0
    
    var backImage: UIImage?
    var titleText: String?
    var slideCounter: String?
    var taskIndex: String?
    
    
    @IBAction func backToMap(_ sender: UIButton) {
       // let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.dismiss(animated: true, completion: nil)
       // self.present(vc, animated: true, completion:nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        slideScrollView.delegate = self
        setupSlideScrollView(slides: slides)
        updateChapter()
    }

    func setupSlideScrollView(slides:[UIView]){
        slideScrollView.subviews.forEach({ $0.removeFromSuperview() })
        slideScrollView.frame = CGRect(x: slideScrollView.frame.minX, y: slideScrollView.frame.minY, width: self.view.frame.width, height: slideScrollView.frame.height)
        slideScrollView.contentSize = CGSize(width: slideScrollView.frame.width*CGFloat(slides.count), height: slideScrollView.frame.height)
        slideScrollView.isPagingEnabled = true
        slideScrollView.showsVerticalScrollIndicator = false
        slideScrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< slides.count{
            slides[i].frame = CGRect(x: slideScrollView.frame.width*CGFloat(i), y: 0, width: slideScrollView.frame.width, height: slideScrollView.frame.height)
            slideScrollView.addSubview(slides[i])
        }
        scrollToPage(page: 0, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pagerIndex.text = String(Int(pageIndex+1))
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.slideScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.slideScrollView.scrollRectToVisible(frame, animated: animated)
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
        if index >= 0 {
            if index<chapterBackground.count{
                backImage = UIImage(named: chapterBackground[index])
            }else{
                backImage = UIImage(named: "bg_task00")
            }
            titleText = tasks[index].header
            slideCounter = "| \(slides.count)"
            taskIndex = String(index+1)
        }
    }
    
    func updateChapter(){
        if index >= 0 {
            backgroundImage.image = backImage
            taskTitle.text = titleText
            pagerCounter.text = slideCounter
            taskNumber.text = taskIndex
        }
    }
    
    func prepareSlides(){
        if index >= 0 {
            slides = factory.prepareSlides(questionSet: tasks[index].slides, callingViewController: self)
        }
    }


}

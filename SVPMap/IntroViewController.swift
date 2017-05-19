//
//  IntroViewController.swift
//  SVPMap
//
//  Created by Jiri Rychlovsky on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import ios_core

/*
 
 ViewController for intro part
 
 */
class IntroViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var slideScrollView: UIScrollView!
    @IBOutlet weak var pagerIndex: UILabel!
    var slides = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideScrollView.delegate = self
        prepareSlides()
        setupSlideScrollView(slides: slides)
        //scrollToPage(page: 3, animated: false)
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
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.slideScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.slideScrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    
    //inserts first 4 slides for intro
    func prepareSlides(){
        let slide1: IntroSlide_01 = Bundle(for: IntroSlide_01.self).loadNibNamed("IntroSlide_01", owner: self, options: nil)?.first as! IntroSlide_01
        
        let slide2: IntroSlide_02 = Bundle(for: IntroSlide_02.self).loadNibNamed("IntroSlide_02", owner: self, options: nil)?.first as! IntroSlide_02
        
        let slide3: IntroSlide_03 = Bundle(for: IntroSlide_03.self).loadNibNamed("IntroSlide_03", owner: self, options: nil)?.first as! IntroSlide_03
        
        let slide4: IntroSlide_04 = Bundle(for: IntroSlide_04.self).loadNibNamed("IntroSlide_04", owner: self, options: nil)?.first as! IntroSlide_04
        slide4.initSlide(parent: self)
        
        slides = [slide1, slide2, slide3, slide4]
    }

}

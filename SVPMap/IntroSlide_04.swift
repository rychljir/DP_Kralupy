//
//  IntroSlide_04.swift
//  SVPMap
//
//  Created by Jiri Rychlovsky on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

/*
 
 Class for xib in the intro of app which starts main ViewController with map
 
 */
class IntroSlide_04: UIView {
    var parent: UIViewController?

    @IBAction func startMap(_ sender: UIButton) {
        parent!.performSegue(withIdentifier: "startMap", sender: sender)
    }
    
    func initSlide(parent: UIViewController){
        self.parent = parent
    }

}

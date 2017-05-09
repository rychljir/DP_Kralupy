//
//  IntroSlide_04.swift
//  SVPMap
//
//  Created by Petr Mares on 08.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

class IntroSlide_04: UIView {
    var parent: UIViewController?

    @IBAction func startMap(_ sender: UIButton) {
        parent!.performSegue(withIdentifier: "startMap", sender: sender)
    }
    
    func initSlide(parent: UIViewController){
        self.parent = parent
    }

}

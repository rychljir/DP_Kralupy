//
//  ChapterViewController.swift
//  SVPMap
//
//  Created by Petr Mares on 07.05.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

class ChapterViewController: UIViewController {
    @IBAction func backToMap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.present(vc, animated: true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }




}

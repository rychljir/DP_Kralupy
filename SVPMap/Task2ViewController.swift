//
//  Task2ViewController.swift
//  SVPMap
//
//  Created by Petr Mares on 15.01.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit

class Task2ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var evalText: UILabel!
    
    @IBAction func evaluate(_ sender: AnyObject) {
        let selectedValue = textField.text
        print("Answer: \(String(describing: selectedValue))")
        if selectedValue == "Swift" || selectedValue == "swift"{
            evalText.text = "SPRAVNE!"
        }else{
            evalText.text = "CHYBA!"
        }
    }

    @IBAction func backToMain(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToMain", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToMain"{
            let pinViewCont = segue.destination as! ViewController
            pinViewCont.title = "Home"
        }
    }

}

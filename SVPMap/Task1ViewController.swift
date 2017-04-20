//
//  PinViewController.swift
//  SVPMap
//
//  Created by Petr Mares on 12.01.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit


class Task1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var picker: UIPickerView!
    
    
    @IBOutlet weak var evalText: UILabel!

     var pickerData: [String] = [String]()
    
    @IBAction func evaluate(_ sender: AnyObject) {
        let selectedValue = pickerData[picker.selectedRow(inComponent: 0)]
        print("Answer: \(selectedValue)")
        if selectedValue == "iPhone OS"{
            evalText.text = "SPRAVNE!"
        }else{
            evalText.text = "CHYBA!"
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToMain", sender: nil)      }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Android", "Windows phone", "iPhone OS", "Blackberry", "Linux"]
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
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

}

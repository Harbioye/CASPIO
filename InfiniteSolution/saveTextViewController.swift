//
//  saveTextViewController.swift
//  InfiniteSolution
//
//  Created by abioye mohammed on 5/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class saveTextViewController: UIViewController {
    
    var results = ""
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var completeText: UILabel!
    
    @IBOutlet weak var saveSpeechText: UITextField!
    @IBOutlet weak var speechTextName: UILabel!
    
    
    @IBOutlet weak var saveFile: UILabel!
    let pickerData = ["My Library", "Groups"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picker.dataSource = self
        picker.delegate = self
        
        let workshop = Workshop(filename: "insert filename", speechText: results)
        
        DataManager.shared.workshops.append(workshop)
        
        
        DataManager.shared.workshops[0].speechText
        
    }
}

extension saveTextViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

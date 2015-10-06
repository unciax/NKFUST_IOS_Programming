//
//  ViewController.swift
//  Calculator
//
//  Created by UnciaX on 2015/9/18.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTyping = false
    var displayValue:Double{
        // To get/set display value on lblDisplayValue
        get{
            return NSNumberFormatter().numberFromString(lblDisplayValue.text!)!.doubleValue
        }
        set{
            lblDisplayValue.text = "\(newValue)"
            isTyping = false
        }
    }
    
    
    @IBOutlet weak var lblDisplayValue: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        if isTyping {
            lblDisplayValue.text = lblDisplayValue.text! + sender.currentTitle!
        }else{
            if sender.currentTitle != "0" {isTyping = true}
            lblDisplayValue.text = sender.currentTitle!
        }
    }
    
    @IBAction func clearAll() {
        displayValue=0
        cBrain.resetAll()
    }

    var cBrain = CalculatorBrain() //() -> 物件初始化
    
    
    @IBAction func selectComputeFunc(sender: UIButton) {
        if sender.currentTitle != nil {
            if isTyping { enterValue() }
            if let result = cBrain.performOperation(sender.currentTitle!){
                displayValue=result
            }else{
                displayValue=0
            }
        }
    }
    
    @IBAction func enterValue() {
        isTyping = false
        if let result = cBrain.puushOperand(displayValue) {
            displayValue = result
        }else{
            displayValue = 0 //Show a error message may be better
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


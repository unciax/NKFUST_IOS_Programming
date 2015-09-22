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
    var operandStack = [Double]()
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
        operandStack.removeAll()
    }

    @IBAction func selectComputeFunc(sender: UIButton) {
        if sender.currentTitle != nil {
            if isTyping { enterValue() }
            switch sender.currentTitle!{
                case "+": performOperation { $0 + $1 }
                case "-": performOperation { $1 - $0 }
                case "×": performOperation { $0 * $1 }
                case "÷": performOperation { $1 / $0 }
                case "√": performOperation { sqrt($0) }
                default: break
            }
  
        }
    }
    
    @IBAction func enterValue() {
        operandStack.append(displayValue)
        print(operandStack)
        isTyping = false
    }
    
    private func performOperation (operation:(Double ,Double)->Double){
        if (operandStack.count >= 2 ){
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enterValue()
        }
    }
    
    private func performOperation (operation:(Double)->Double){
        displayValue = operation(operandStack.removeLast())
        enterValue()
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


//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Miretz Dev on 16/12/2017.
//  Copyright © 2017 Miretz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var numberOnScreen = 0.0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = isFractionInput ? numbersAfterDot : 0
            formatter.maximumFractionDigits = 10
            display.text = formatter.string(from: numberOnScreen as NSNumber) ?? "0"
        }
    }
    
    var previousNumber = 0.0
    var shouldClearBeforeInput = false
    
    //if fraction input is true, the user can type for example 0.00.., without the formater truncating the zero after the dot
    var isFractionInput = false
    var numbersAfterDot = 0
    
    var currentOperation = Operation.none
    enum Operation {
        case none
        case divide
        case multiply
        case minus
        case plus
    }
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let text = display.text {
            let substring = String(text.dropLast())
            numberOnScreen = Double(substring.isEmpty ? "0" : substring) ?? 0.0
        }
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if let text = display.text, !text.contains(".") {
            display.text = text + "."
            isFractionInput = true
        }
    }
    
    private func resetFractionInput(){
        isFractionInput = false
        numbersAfterDot = 0
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if let text = display.text {

            let enteredNumber = String(sender.tag-1) // tag is number + 1
            
            if shouldClearBeforeInput { resetFractionInput() }
            if isFractionInput { numbersAfterDot += 1 }
            
            //clear if there's only a 0, replicating how standard calculators work
            let displayText = (shouldClearBeforeInput || text=="0") ? enteredNumber : text + enteredNumber
            shouldClearBeforeInput = false

            numberOnScreen = Double(displayText) ?? 0.0
        }
    }
    
    private func performCurrentOperation(){
        switch currentOperation {
        case .none: return
        case .divide:
            if numberOnScreen != 0 {
                numberOnScreen = previousNumber / numberOnScreen
            } else {
                resetCalculator() // dividing by zero will reset the calculator
            }
        case .multiply:
            numberOnScreen = previousNumber * numberOnScreen
        case .minus:
            numberOnScreen = previousNumber - numberOnScreen
        case .plus:
            numberOnScreen = previousNumber + numberOnScreen
        }
        previousNumber = 0.0
        currentOperation = Operation.none
    }
    
    private func resetCalculator(){
        resetFractionInput()
        previousNumber = 0.0
        currentOperation = Operation.none
        numberOnScreen = 0.0
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
        resetFractionInput()
        
        //execute the last operation before creating a new one
        if currentOperation != Operation.none {
            performCurrentOperation()
        }
        
        switch (sender.tag) {
        case 11: // reset
            resetCalculator()
        case 16: // =
            performCurrentOperation()
        case 12: // divide
            previousNumber = numberOnScreen
            currentOperation = Operation.divide
        case 13: // multiply
            previousNumber = numberOnScreen
            currentOperation = Operation.multiply
        case 14: // minus
            previousNumber = numberOnScreen
            currentOperation = Operation.minus
        case 15: // plus
            previousNumber = numberOnScreen
            currentOperation = Operation.plus
        default: break
        }
        
        shouldClearBeforeInput = true
        
    }
    
}


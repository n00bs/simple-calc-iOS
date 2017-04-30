//
//  ViewController.swift
//  simple-calc
//
//  Created by Abhishek Chauhan on 4/16/17.
//  Copyright © 2017 Abhishek Chauhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    var numberOnScreen: Int? = nil
    var numberList: [Int] = []
    var actionList: [String] = []
    var resultOperation: Int? = nil
    var historyList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        let historyViewController = segue.destination as! HistoryViewController
        
        // set a variable in the second view controller with the data to pass
        historyViewController.data = historyList
    }
    
    
    @IBAction func number(_ sender: UIButton) {
        if (self.resultOperation != nil || self.numberLabel.text == "0") {
            self.numberLabel.text = ""
            self.resultOperation = nil
        }
        self.numberLabel.text = self.numberLabel.text! + sender.titleLabel!.text!
        self.numberOnScreen = self.numberOnScreen == nil ? 0 : self.numberOnScreen
        self.numberOnScreen = self.numberOnScreen! * 10 + Int(sender.titleLabel!.text!)!
    }
    
    @IBAction func operand(_ sender: UIButton) {
        if (self.numberOnScreen == nil || self.actionList.contains("Count") || self.actionList.contains("Average")) {
            self.error()
            return
        }
        self.numberList.append(self.numberOnScreen!)
        self.numberOnScreen = nil
        
        let op = sender.titleLabel!.text!
        switch op {
            case "%" :
                self.numberLabel.text! += " mod "
            case "+":
                self.numberLabel.text! += " add "
            case "-":
                self.numberLabel.text! += " sub "
            case "*":
                self.numberLabel.text! += " mul "
            case "/":
                self.numberLabel.text! += " div "
            case "Factorial":
                self.numberLabel.text! += " fact "
            default:
                self.error()
                return
        }
        self.actionList.append(op)
    }
    
    @IBAction func multiOperand(_ sender: UIButton) {
        if (self.numberOnScreen == nil || self.actionList.count > 1) {
            self.error()
            return
        } else if (self.actionList.count != 0 && !self.actionList.contains(sender.titleLabel!.text!)) {
            self.error()
            return
        }
        self.numberList.append(self.numberOnScreen!)
        self.numberOnScreen = nil
        
        let op = sender.titleLabel!.text!
        switch op {
            case "Count" :
                self.numberLabel.text! += " count "
            case "Average":
                self.numberLabel.text! += " avg "
            default:
                self.error()
                return
        }
        self.actionList = [op]
    }
    
    @IBAction func result(_ sender: UIButton) {
        if (self.numberOnScreen != nil) {
            if (self.actionList[self.actionList.count-1] == "Factorial") {
                self.error()
                return
            }
            self.numberList.append(self.numberOnScreen!)
        } else if (self.actionList.count != 0) {
            let lastInList = self.actionList[self.actionList.count-1]
            if (lastInList != "Factorial" && lastInList != "Average" && lastInList != "Count") {
                self.error()
                return
            }
        }
        
        self.numberOnScreen = nil
        self.resultOperation = self.numberList.count != 0 ? self.numberList[0] : 0
        for i in 0 ..< self.actionList.count {
            let action = self.actionList[i]
            switch action {
                case "Count":
                    self.resultOperation = self.count(numberList)
                case "Average":
                    self.resultOperation = self.average(numberList)
                case "Factorial":
                    self.resultOperation = self.fact(self.resultOperation!)
                case "+":
                    self.resultOperation = self.add(self.resultOperation!, self.numberList[i+1])
                case "-":
                    self.resultOperation = self.subtract(self.resultOperation!, self.numberList[i+1])
                case "*":
                    self.resultOperation = self.multiply(self.resultOperation!, self.numberList[i+1])
                case "/":
                    // Handles the case where number is divided by 0
                    if (self.numberList[i+1] == 0) {
                        self.error()
                        return
                    }
                    self.resultOperation = self.divide(self.resultOperation!, self.numberList[i+1])
                case "%":
                    // Handles the case where number is mod by 0
                    if (self.numberList[i+1] == 0) {
                        self.error()
                        return
                    }
                    self.resultOperation = self.mod(self.resultOperation!, self.numberList[i+1])
                default:
                    return
            }
        }
        self.actionList = []
        self.numberList = []
        let textToList = String("\(self.numberLabel!.text!) = \(self.resultOperation!)")
        self.historyList.append(textToList!)
        self.numberLabel.text = String(self.resultOperation!)
    }
    
    func error() {
        self.numberLabel.text = "Invalid operation"
        self.resultOperation = 0
        self.actionList = []
        self.numberList = []
        self.numberOnScreen = nil
    }
    
    func add(_ left: Int, _ right: Int) -> Int {
        return left + right
    }
    
    func subtract(_ left: Int, _ right: Int) -> Int {
        return left - right
    }
    
    func multiply(_ left: Int, _ right: Int) -> Int {
        return left * right
    }
    
    func divide(_ left: Int, _ right: Int) -> Int {
        return left / right
    }
    
    func mod(_ left: Int, _ right: Int) -> Int {
        return left % right
    }
    
    func fact(_ number: Int) -> Int {
        var factorial : Int = 1
        for i in 1 ... number {
            factorial *= i
        }
        return factorial
    }
    
    func count(_ numbers: [Int]) -> Int {
        return numbers.count
    }
    
    func average(_ numbers: [Int]) -> Int {
        var sum  = 0
        for number in numbers {
            sum += number
        }
        return sum / self.count(numbers)
    }
    
}



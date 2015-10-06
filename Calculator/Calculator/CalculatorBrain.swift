//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by UnciaX on 2015/9/22.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case Op.Operand(let operand): return  "\(operand)"
                case Op.UnaryOperation(let symbol, _): return symbol
                case Op.BinaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    // or -> var knownOps = Dictionary<String, Op>()
    // Dictionary<key type, value type>
    
    init(){
        knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
        knownOps["sinx"] = Op.UnaryOperation("sinx") { sin($0) }
        knownOps["cosx"] = Op.UnaryOperation("cosx") { cos($0) }
        knownOps["+/-"] = Op.UnaryOperation("+/-") { if($0>0) {return $0-2*$0} else {return abs($0)} }
        // or -> knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    // Evaluation
    
    private func evaluate(ops: [Op]) -> (result:Double?, remainingOps:[Op]) {
        //return a tuple
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return(operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evalation = evaluate(remainingOps)
                    if let operand1 = op1Evalation.result {
                        let op2Evalation = evaluate(op1Evalation.remainingOps)
                        if let operand2 = op2Evalation.result{
                            return(operation(operand1,operand2),op2Evalation.remainingOps)
                        }
                    }
            }
            
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        
        print("\(opStack) equals \(result) with \(remainder) left")
        return result
    }
    
    func puushOperand(operand : Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol : String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func resetAll(){
        opStack.removeAll()
    }
    
}
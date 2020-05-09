//
//  Vec2GeneratorNodeData.swift
//  Book_Sources
//
//  Created by Justin Fincher on 19/3/2019.
//

import UIKit

class Vec2GeneratorNodeData: NodeData, UITextFieldDelegate
{
    var xValue : Dynamic<Float> = Dynamic<Float>(0)
    var yValue : Dynamic<Float> = Dynamic<Float>(0)
    
    override class var defaultTitle: String { return "Vec2 Generator (vec2(x,y))" }
    override class var customViewHeight: CGFloat { return 80 }
    override class var defaultCanHavePreview: Bool { return false }
    override class var defaultPreviewOutportIndex: Int { return -1 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return []
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            Vec2NodePortData(title: "Result")
        ]
    }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = vec2(\(xValue.value),\(yValue.value));
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()).x,\(outPorts[0].getPortVariableName()).y,0.0,1.0);")
    }
    
    override func setupCustomView(view: UIView)
    {
        let xInputField : UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2.0, height: self.customViewHeight).inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 4)))
        view.addSubview(xInputField)
        xInputField.backgroundColor = UIColor.clear
        xInputField.font = UIFont.init(name: Constant.fontBoldName, size: 60)
        xInputField.adjustsFontSizeToFitWidth = true
        xInputField.minimumFontSize = 20
        xInputField.placeholder = "X"
        xInputField.text = "\(xValue.value)"
        xInputField.keyboardType = .decimalPad
        xInputField.delegate = self
        xInputField.accessibilityIdentifier = "X"
        
        let yInputField : UITextField = UITextField(frame: CGRect(x: self.frame.width / 2.0, y: 0, width: self.frame.width / 2.0, height: self.customViewHeight).inset(by: UIEdgeInsets.init(top: 8, left: 4, bottom: 8, right: 8)))
        view.addSubview(yInputField)
        yInputField.backgroundColor = UIColor.clear
        yInputField.font = UIFont.init(name: Constant.fontBoldName, size: 60)
        yInputField.adjustsFontSizeToFitWidth = true
        yInputField.minimumFontSize = 20
        yInputField.placeholder = "Y"
        yInputField.text = "\(yValue.value)"
        yInputField.keyboardType = .decimalPad
        yInputField.delegate = self
        yInputField.accessibilityIdentifier = "Y"
        
        xValue.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
        yValue.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
    }
    
    // MARK - UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let text = textField.text, let nextValue = Float(text)
        {
            if textField.accessibilityIdentifier == "X"
            {
                xValue.value = nextValue
            }else if textField.accessibilityIdentifier == "Y"
            {
                yValue.value = nextValue
            }
            textField.text = "\(nextValue)"
        }
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let text = textField.text, let nextValue = Float(text)
        {
            if textField.accessibilityIdentifier == "X"
            {
                xValue.value = nextValue
            }else if textField.accessibilityIdentifier == "Y"
            {
                yValue.value = nextValue
            }
            textField.text = "\(nextValue)"
        }
        return true
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Generator
    }
}

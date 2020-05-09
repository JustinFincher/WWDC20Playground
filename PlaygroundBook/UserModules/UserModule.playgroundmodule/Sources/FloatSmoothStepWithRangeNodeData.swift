//
//  FloatSmoothStepWithRangeNodeData.swift
//  Book_Sources
//
//  Created by Justin Fincher on 19/3/2019.
//

import UIKit

class FloatSmoothStepWithRangeNodeData: NodeData, UITextFieldDelegate
{
    
    var leftValue : Dynamic<Float> = Dynamic<Float>(0)
    var rightValue : Dynamic<Float> = Dynamic<Float>(1)
    
    override class var customViewHeight: CGFloat { return 80 }
    override class var defaultTitle: String { return "Float SmoothStep With Range" }
    override class var defaultCanHavePreview: Bool { return true }
    override class var defaultPreviewOutportIndex: Int { return 0 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "X")
        ]
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "Result")
        ] }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = smoothstep(\(leftValue.value),\(rightValue.value),\(inPorts[0].getPortVariableName()));
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),1.0);")
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Modifier
    }
    
    override func setupCustomView(view: UIView)
    {
        let leftInputField : UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2.0, height: self.customViewHeight).inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 4)))
        view.addSubview(leftInputField)
        leftInputField.backgroundColor = UIColor.clear
        leftInputField.font = UIFont.init(name: Constant.fontBoldName, size: 60)
        leftInputField.adjustsFontSizeToFitWidth = true
        leftInputField.minimumFontSize = 20
        leftInputField.placeholder = "Left"
        leftInputField.text = "\(leftValue.value)"
        leftInputField.keyboardType = .decimalPad
        leftInputField.delegate = self
        leftInputField.accessibilityIdentifier = "Left"
        
        let rightInputField : UITextField = UITextField(frame: CGRect(x: self.frame.width / 2.0, y: 0, width: self.frame.width / 2.0, height: self.customViewHeight).inset(by: UIEdgeInsets.init(top: 8, left: 4, bottom: 8, right: 8)))
        view.addSubview(rightInputField)
        rightInputField.backgroundColor = UIColor.clear
        rightInputField.font = UIFont.init(name: Constant.fontBoldName, size: 60)
        rightInputField.adjustsFontSizeToFitWidth = true
        rightInputField.minimumFontSize = 20
        rightInputField.placeholder = "Right"
        rightInputField.text = "\(rightValue.value)"
        rightInputField.keyboardType = .decimalPad
        rightInputField.delegate = self
        rightInputField.accessibilityIdentifier = "Right"
        
        leftValue.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
        rightValue.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
    }
    
    // MARK - UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let text = textField.text, let nextValue = Float(text)
        {
            if textField.accessibilityIdentifier == "Left"
            {
                leftValue.value = nextValue
            }else if textField.accessibilityIdentifier == "Right"
            {
                rightValue.value = nextValue
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
            if textField.accessibilityIdentifier == "Left"
            {
                leftValue.value = nextValue
            }else if textField.accessibilityIdentifier == "Right"
            {
                rightValue.value = nextValue
            }
            textField.text = "\(nextValue)"
        }
        return true
    }
}


//
//  FloatNodeData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 16/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

@objc public class FloatGeneratorNodeData: NodeData, UITextFieldDelegate
{
    var value : Dynamic<Float> = Dynamic<Float>(0)
    
    override class var defaultTitle: String { return "Float Generator (float a)" }
    override class var customViewHeight: CGFloat { return 100 }
    override class var defaultCanHavePreview: Bool { return false }
    override class var defaultPreviewOutportIndex: Int { return -1 }
    override class var defaultInPorts: Array<NodePortData>
    {
        return []
    }
    override class var defaultOutPorts: Array<NodePortData>
    {
        return [
            FloatNodePortData(title: "A")
        ]
    }
    
    // single node shader block, need to override
    override func singleNodeExpressionRule() -> String
    {
        let result : String =
        """
        \(shaderCommentHeader())
        \(declareInPortsExpression())
        \(outPorts[0].requiredType.defaultCGType) \(outPorts[0].getPortVariableName()) = \(value.value);
        """
        return result
    }
    
    // preview shader expression gl_FragColor only, need to override
    override func shaderFinalColorExperssion() -> String
    {
        return String(format: "gl_FragColor = vec4(\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),\(outPorts[0].getPortVariableName()),1.0);")
    }
    
    override func setupCustomView(view: UIView)
    {
        let inputField : UITextField = UITextField(frame: view.bounds.inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)))
        view.addSubview(inputField)
        inputField.backgroundColor = UIColor.clear
        inputField.font = UIFont.init(name: Constant.fontBoldName, size: 80)
        inputField.adjustsFontSizeToFitWidth = true
        inputField.minimumFontSize = 28
        inputField.placeholder = "Value"
        inputField.text = "\(value.value)"
        inputField.keyboardType = .decimalPad
        inputField.delegate = self
        
        value.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
    }
    
    // MARK - UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let text = textField.text, let nextValue = Float(text)
        {
            value.value = nextValue
            textField.text = "\(nextValue)"
        }
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if let text = textField.text, let nextValue = Float(text)
        {
            value.value = nextValue
            textField.text = "\(nextValue)"
        }
        return true
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Generator
    }
}


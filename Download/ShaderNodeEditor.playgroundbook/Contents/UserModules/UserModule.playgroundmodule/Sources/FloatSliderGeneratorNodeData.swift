import UIKit
import Combine

@objc(FloatSliderGeneratorNodeData) public class FloatSliderGeneratorNodeData: NodeData
{
    var value : Dynamic<Float> = Dynamic<Float>(0)
    var valueSub : AnyCancellable?
    
    override class var defaultTitle: String { return "Float Slider (float a)" }
    override class var customViewHeight: CGFloat { return 60 }
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
        let slider : UISlider = UISlider(frame: view.bounds.inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)))
        view.addSubview(slider)
        slider.maximumValue = 1
        slider.maximumValueImage = UIImage.init(systemName: "1.square")
        slider.minimumValue = 0
        slider.minimumValueImage = UIImage.init(systemName: "0.square")
        slider.isContinuous = true
        slider.tintColor = UIColor.secondarySystemFill
        slider.value = value.value
        
        valueSub = slider.publisher(for: .valueChanged)
            .map { ($0 as! UISlider).value }
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { (f) in
                self.value.value = f
           }
        
        value.bind { (newValue) in
            NotificationCenter.default.post(name: NSNotification.Name( Constant.notificationNameShaderModified), object: nil)
        }
    }
    
    override class func nodeType() -> NodeType
    {
        return NodeType.Generator
    }
}


import UIKit

public class NodePortKnotView: UIView
{
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        return CGRect.init(x: 4, y: 4, width: self.frame.size.width - 8, height: self.frame.size.height - 8).contains(point) ? self : nil
    }

}

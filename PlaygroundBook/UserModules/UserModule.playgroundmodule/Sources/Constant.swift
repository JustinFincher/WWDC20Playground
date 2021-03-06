import UIKit

public class Constant: NSObject
{
    public static let nodeScaleNormal : CGFloat = 1.0
    public static let nodeScaleZoomed : CGFloat = 1.1
    public static let nodePadding : CGFloat = 8
    public static let nodeWidth : CGFloat = 200
    public static let nodePortKnotWidth : CGFloat = 30
    public static let nodePortHeight : CGFloat = 40
    public static let nodeTitleHeight : CGFloat = 20
    public static let nodeConnectionCurveControlOffset : CGFloat = 90
    public static let fontObliqueName = "Avenir-Oblique"
    public static let fontBoldName = "Avenir-Black"
    public static let tutorialRowHeight : CGFloat = 128
    public static let nodeKnotIndicatorColor = UIColor.tertiarySystemFill.withAlphaComponent(0.4)
    public static let lineNormalColor = UIColor.systemYellow.withAlphaComponent(0.6)
    public static let lineRejectColor = UIColor.systemRed.withAlphaComponent(0.6)
    public static let lineSupportedColor = UIColor.systemGreen.withAlphaComponent(0.6)
    public static let notificationNameShaderModified = "notificationNameShaderModified"
    public static let notificationNamePowerUpEnabledForPlayground = "notificationNamePowerUpEnabledForPlayground"
    public static let useReflectionToGetNodeList : Bool = false
}

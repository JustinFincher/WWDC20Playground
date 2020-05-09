import Foundation
import UIKit

extension FileManager
{
    func createTemporaryDirectory() throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }
}

public extension UIView
{
    func getSuperView(typeClass: AnyClass) -> UIView?
    {
        weak var view : UIView? = self
        while view != nil, !view!.isKind(of: typeClass)
        {
            view = view!.superview
        }
        if view != nil && view!.isKind(of: typeClass)
        {
            return view
        }
        return nil
    }
}

public extension CGRect
{
    func center() -> CGPoint
    {
        return CGPoint.init(x: self.origin.x + self.size.width / 2.0, y: self.origin.y + self.size.height / 2.0)
    }
}
public extension CGPoint
{
    func applyOffset(x: CGFloat, y: CGFloat) -> CGPoint
    {
        return CGPoint.init(x: self.x + x, y: self.y + y)
    }
}
public extension NSObject
{
    class func getClassHierarchy() -> [AnyClass] {
        var hierarcy = [AnyClass]()
        hierarcy.append(self.classForCoder())
        var currentSuper: AnyClass? = class_getSuperclass(self.classForCoder())
        while currentSuper != nil {
            hierarcy.append(currentSuper!)
            currentSuper = class_getSuperclass(currentSuper)
        }
        
        return hierarcy
    }
    
    class func getAllClasses() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate()
        return classes
    }

    class func directSubclasses() -> [AnyClass]
    {
        var result: Array<AnyClass> = []
        
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
//        DispatchQueue.concurrentPerform(iterations: Int(actualClassCount)) { (index) in
//
//            if let currentClass: AnyClass = allClasses[index]
//            {
//                if let currentSuper = class_getSuperclass(currentClass)
//                {
//                    if (String(describing: currentSuper) == String(describing: self))
//                    {
//                        result.append(currentClass)
//                    }
//                }
//            }
//
//        }
        
        for i in 0 ..< actualClassCount
        {
            if let currentClass: AnyClass = allClasses[Int(i)]
            {
                guard let currentSuper = class_getSuperclass(currentClass) else
                {
                    continue
                }
                if (String(describing: currentSuper) == String(describing: self))
                {
                    result.append(currentClass)
                }
            }
        }
        allClasses.deallocate()
        return result
    }
}

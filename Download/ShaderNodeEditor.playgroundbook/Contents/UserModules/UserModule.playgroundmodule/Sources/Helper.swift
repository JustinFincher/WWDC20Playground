//
//  Helper.swift
//  UserModule
//
//  Created by fincher on 5/11/20.
//

import Foundation


public class Helper
{
    static func subclasses<T>(of theClass: T) -> [T] {
        var count: UInt32 = 0, result: [T] = []
        let allClasses = objc_copyClassList(&count)!

        for n in 0 ..< count {
            let someClass: AnyClass = allClasses[Int(n)]
            guard let someSuperClass = class_getSuperclass(someClass), String(describing: someSuperClass) == String(describing: theClass) else { continue }
            result.append(someClass as! T)
        }

        return result
    }
    
    static func subclassNames<T>(of theClass: T) -> [String] {
        var count: UInt32 = 0, result: [String] = []
        let allClasses = objc_copyClassList(&count)!

        for n in 0 ..< count {
            let someClass: AnyClass = allClasses[Int(n)]
            guard let someSuperClass = class_getSuperclass(someClass), String(describing: someSuperClass) == String(describing: theClass) else { continue }
            result.append(String(describing: someClass))
        }
        return result
    }

    static func address(of object: Any?) -> UnsafeMutableRawPointer{
        return Unmanaged.passUnretained(object as AnyObject).toOpaque()
    }
}

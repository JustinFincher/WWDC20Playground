//
//  ShaderFloatType.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 17/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class ShaderFloatType: ShaderDataType
{
    override class var defaultCGType : String { return "float" }
    override class var defaultCGValue : String { return "0.0" }
}

//
//  ShaderVec4Type.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class ShaderVec4Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec4" }
    override class var defaultCGValue : String { return "vec4(0.0)" }
}

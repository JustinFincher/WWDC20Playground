//
//  ShaderVec3Type.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class ShaderVec3Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec3" }
    override class var defaultCGValue : String { return "vec3(0.0)" }
}

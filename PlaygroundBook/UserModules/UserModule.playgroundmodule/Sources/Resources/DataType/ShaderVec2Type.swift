//
//  ShaderVec2Type.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class ShaderVec2Type: ShaderDataType
{
    override class var defaultCGType : String { return "vec2" }
    override class var defaultCGValue : String { return "vec2(0.0)" }
}

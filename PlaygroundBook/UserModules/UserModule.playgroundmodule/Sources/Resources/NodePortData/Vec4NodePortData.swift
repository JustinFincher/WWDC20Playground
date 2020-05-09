//
//  Vec4NodePortData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec4NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec4" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec4Type.self }
}

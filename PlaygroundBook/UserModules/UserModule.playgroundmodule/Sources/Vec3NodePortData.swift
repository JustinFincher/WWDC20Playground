//
//  Vec3NodePortData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec3NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec3" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec3Type.self }
}

//
//  Vec2NodePortData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 18/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class Vec2NodePortData: NodePortData
{
    override class var defaultTitle : String { return "Vec2" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderVec2Type.self }
}

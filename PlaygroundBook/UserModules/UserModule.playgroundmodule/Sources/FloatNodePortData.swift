//
//  FloatNodePortData.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 17/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class FloatNodePortData: NodePortData
{
    override class var defaultTitle : String { return "Float" }
    override class var defaultRequiredType : ShaderDataType.Type { return ShaderFloatType.self }
}

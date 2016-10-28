//
//  ZYColumnDownPromptView.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit

class ZYColumnDownPromptView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化提示label
        let label = UILabel(frame:CGRect(x: kColumnMarginW, y: 0, width: 150, height: frame.height))
        label.text = "点击添加更多栏目"
        label.textColor = UIColor.darkGray
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

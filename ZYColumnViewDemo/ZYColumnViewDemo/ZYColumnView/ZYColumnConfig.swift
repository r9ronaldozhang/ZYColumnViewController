//
//  ZYColumnConfig.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit

/******** 在此文件中定义了此控件常用的常用尺寸变量，用户可根据自己需求进行修改 ********/

let kColumnScreenW = UIScreen.main.bounds.size.width
let kColumnScreenH = UIScreen.main.bounds.size.height

let kColumnViewH:CGFloat = 40.0                                         // 默认高度
let kColumnViewW = kColumnScreenW                                       // 默认宽度
let kSpreadMaxH:CGFloat = kColumnScreenH - 64                           // 默认下拉展开的最大高度
let kSpreadDuration = 0.4                                               // 动画展开收拢的时长
let kColumnLayoutCount = 4                                              // 排序item 每行个数
let kColumnItemH:CGFloat = (ZYinch55()) ? 40: 30                        // item的高度
let kColumnItemW:CGFloat = (ZYinch55()) ? 85: 70                        // item的宽度
let kColumnMarginW:CGFloat = (ZYScreenWidth-CGFloat(kColumnLayoutCount)*kColumnItemW)/CGFloat(kColumnLayoutCount+1)                                       // item的横向间距
let kColumnMarginH:CGFloat = (ZYinch55()) ? 20:((ZYinch47()) ? 20: 15)  // item的纵向间距
let kColumnEditBtnW:CGFloat = 60                                        // 排序删除按钮的宽度
let kColumnEditBtnH:CGFloat = 36                                        // 排序删除按钮的高度
let kColumnEditBtnFont:CGFloat = 10                                     // 排序删除按钮的字体
let kColumnEditBtnNorTitle = "排序删除"                                   // 排序删除普通状态文字
let kColumnEditBtnSelTitle = "完成"                                      // 排序删除选中状态文字
let kColumnItemBorderColor = UIColor.red.cgColor                        // item的色环
let kColumnItemColor = UIColor.red                                      // item的文字颜色

let kColumnTitleMargin:CGFloat = 8                                      // title按钮之间默认没有间距，这个值保证两个按钮的间距
let kColumnTitleNorColor = UIColor.darkText                             // title普通状态颜色
let kColumnTitleSelColor = UIColor.red                                  // title选中状态颜色
let kColumnTitleNorFont:CGFloat = (ZYinch47() || ZYinch55()) ? 14 : 13  // title普通状态字体
let kColumnTitleSelFont:CGFloat = (ZYinch47() || ZYinch55()) ? 16 : 15  // title选中状态字体
let kColumnHasIndicator = true                                          // 默认有指示线条
let kColumnIndictorH:CGFloat = 2.0                                      // 指示线条高度
let kColumnIndictorMinW : CGFloat = 60                                  // 指示条默认最小宽度
let kColumnIndicatorColor = UIColor.red                                 // 默认使用系统风格颜色

/************** 常量定义 ****************/
/// 是否是3.5英寸屏
func ZYinch35() -> Bool {
    return UIScreen.main.bounds.size.height == 480.0
}

/// 是否是4.0英寸屏
func ZYinch40() -> Bool {
    return UIScreen.main.bounds.size.height == 568.0
}
/// 是否是4.7英寸屏
func ZYinch47() -> Bool {
    return UIScreen.main.bounds.size.height == 667.0
}
/// 是否是5.5英寸屏
func ZYinch55() -> Bool {
    return UIScreen.main.bounds.size.height == 736.0
}

let ZYScreenWidth  = UIScreen.main.bounds.width
let ZYScreenHeight = UIScreen.main.bounds.height

//
//  ViewController.swift
//  ZYColumnViewDemo
//
//  Created by 张宇 on 2016/10/28.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

import UIKit

class ViewController: UIViewController , ZYColumnViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        
        // 注意，arrayTitles 不能为空
        let arrayTitles = ["头条","财经","体育","娱乐圈","段子","健康","图片","军事","精选","国际足球","历史","跟帖","居家"]
        let arraySpareTitles = ["房产","直播","轻松一刻","独家","社会","手机","数码","酒香","美女","艺术","读书","情感","论坛","博客","NBA","旅游","跑步","影视","政务","本地","汽车","公开课","游戏","独家","时尚","轻松一刻","社会","漫画"]
        self.initColumnVC(arrayTitles, arraySpareTitles, 1)
    }
    
    /// 在ZYColumnConfig里面DIY 按照你需求调整UI
    /// 展开view 里面的 item 代码比较简单，修改Item样式 可以直接修改 ZYColumnItem ,不会影响代码逻辑功能
    
    /// 创建 columnVC   就这几行代码，啥功能都有了
    private func initColumnVC(_ titles : [String], _ spareTitles : [String] , _ fixCount : Int){
        // 初始化columnVC
        let columnVC = ZYColumnViewController()
        columnVC.view.frame = CGRect(x: 0, y: 30, width: ZYScreenWidth, height: 40)
        columnVC.arrayTitles = titles
        if spareTitles.count > 0 {
            columnVC.arraySpareTitles = spareTitles
        }
        columnVC.fixedCount = fixCount
        columnVC.delegate = self
        view.addSubview(columnVC.view)
        addChildViewController(columnVC)
    }
    
    /// 三个代理方法，能够满足你需求的数据
    func columnViewControllerSetTitle(setTitle: String, index: Int) {
        
    }
    
    func columnViewControllerSelectedTitle(selectedTitle: String, index: Int) {
        
    }
    
    func columnViewControllerTitlesDidChanged(arrayTitles: [String]!, spareTitles: [String]?) {
        
    }
}


//
//  ZYColumnViewController.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit

@objc protocol ZYColumnViewControllerDelegate : class {
    // 上面选择的数组和被选择的数组 回调传值
    @objc optional func columnViewControllerTitlesDidChanged(arrayTitles : [String]!, spareTitles : [String]?)
    // 当前用户选择的按钮标题和所处的索引
    @objc optional func columnViewControllerSelectedTitle(selectedTitle : String, index : Int)
    // 用户手动调用控制器，选择的title 和 所在索引
    @objc optional func columnViewControllerSetTitle(setTitle: String , index : Int)
}

class ZYColumnViewController: UIViewController {
    
    open var arrayTitles = [String](){
        didSet {
            // 数据校验
            guard arrayTitles.count > 0 else {
                fatalError("if you want to use it, arrayTitles can not be nil ")
            }
            for _ in view.subviews {     // 已经初始化过了，直接return 避免赋值后重复执行下面的代码
                return
            }
            // 默认选中第0个栏目名称
            selTitle = arrayTitles[0]
            // 初始化横向滚动scrollView
            view.addSubview(hScrollView)
            // 初始化"展开"按钮
            setupSpreadButton()
        }
    }
    // 备选 string 数组
    open var arraySpareTitles = [String]()
    // 固定不变的item 个数
    open var fixedCount = 1
    // 代理
    weak var delegate : ZYColumnViewControllerDelegate?
    
    /************* 上面是对外属性 -----华丽分割线----- 下面是私有属性 ***************/
    
    // 右边的展开按钮
    fileprivate var spreadBtn: UIButton = UIButton()
    // 是否 展开 标识
    fileprivate var toSpread:Bool = false
    // 用户当前选中的栏目名称
    fileprivate var selTitle = String()
    
    // MARK: - 懒加载
    /// 垂直展开的scrollView
    fileprivate lazy var spreadView:ZYColumnSpreadView = {
        let spreadView = ZYColumnSpreadView(frame: CGRect(x: 0, y: 0, width: kColumnScreenW, height: 0.1))
        spreadView.arrayUpTitles = self.arrayTitles
        spreadView.arrayDownTitles = self.arraySpareTitles
        spreadView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        spreadView.fixedCount = self.fixedCount
        self.view.insertSubview(spreadView, belowSubview: self.hScrollView)
        
        spreadView.tapClosure = {
            [weak self](item : ZYColumnItem) -> Void in
            // 回调处理
            // 收起spreadView
            self!.spreadOrFlod()
            if self!.selTitle != item.title {       // 点击的不是当前选中的才设置，并且回传值
                // 这里可以拿到用户点击的具体title 如果用户已经删除之前选中的title 则认为用户选择了第0个
                self!.selTitle = (self!.arrayTitles.contains(item.title)) ? item.title : self!.arrayTitles[0]
                self!.hScrollView.changeItemToSelected(title: self!.selTitle)
                // 代理传值
                self!.delegate?.columnViewControllerSelectedTitle!(selectedTitle : self!.selTitle, index:
                    self!.arrayTitles.index(of: self!.selTitle)!)
            }
        }
        spreadView.longPressClosure = {
            [weak self]() -> Void in
            // 模拟用户点击了一下edit按钮
            self!.upPromptView.editButtonClick(editBtn: self!.upPromptView.editBtn!)
        }
        spreadView.flodClosure = {
            [weak self](upArrayTitles : [String], downArrayTitles : [String]) -> Void in
            guard upArrayTitles != self!.arrayTitles else {     // 两个数组相等，说明没有变化，下面代码不用执行
                return
            }
            self!.arrayTitles = upArrayTitles
            self!.arraySpareTitles = downArrayTitles
            self!.hScrollView.arrayTitles = upArrayTitles
            // 如果用户已经删除之前选中的title 则认为用户选择了第0个
            self!.selTitle = (upArrayTitles.contains(self!.selTitle)) ? self!.selTitle : self!.arrayTitles[0]
            self!.hScrollView.changeItemToSelected(title: self!.selTitle)
            // 代理传值
            self!.delegate?.columnViewControllerSelectedTitle!(selectedTitle: self!.selTitle, index:
                self!.arrayTitles.index(of: self!.selTitle)!)
            self!.delegate?.columnViewControllerTitlesDidChanged!(arrayTitles: self!.arrayTitles, spareTitles: self!.arraySpareTitles)
            
        }
        return spreadView
    }()
    
    /// 横向滚动的scrollView
    fileprivate lazy var hScrollView : ZYColumnHScrollView = {
        let hScrollView = ZYColumnHScrollView()
        // 回调
        hScrollView.backClosure = {
            [weak self](tag : Int, title: String) -> Void in
            if title != self!.selTitle {        // 点击的不是当前选中的才设置，并且回传值
                self!.selTitle = title
                // 代理传值
                self!.delegate?.columnViewControllerSelectedTitle!(selectedTitle: self!.selTitle, index:
                    self!.arrayTitles.index(of: self!.selTitle)!)
            }
        }
        hScrollView.arrayTitles = self.arrayTitles
        hScrollView.frame = CGRect(x: 0, y: 0, width: ZYScreenWidth-kColumnViewH, height: kColumnViewH)
        hScrollView.backgroundColor = UIColor.white
        hScrollView.changeItemToSelected(title: self.arrayTitles[0])      // 初始化的时候默认选中第0个
        self.view.addSubview(hScrollView)
        return hScrollView
    }()
    
    /// 透明的cover,当展开状态，导航条覆盖一个cover,点击cover会收起
    lazy fileprivate var cover : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: kColumnScreenW , height: 64))
        btn.backgroundColor = UIColor(white: 1.0, alpha: 0.001)
        UIApplication.shared.keyWindow?.addSubview(btn)
        btn.addTarget(self, action: #selector(self.spreadBtnClick(spreadBtn:)), for: .touchUpInside)       //等价于点了展开按钮
        return btn
    }()
    /// 上提示view
    lazy var upPromptView : ZYColumnUpPromptView = {
        let upView = ZYColumnUpPromptView(frame: CGRect(x: 0, y: 0, width: kColumnViewW - kColumnViewH, height: kColumnViewH))
        upView.backgroundColor = UIColor.white
        // 闭包回调处理
        upView.clickClosure = {
            [weak self](isSelected : Bool) -> Void in
            // 编辑按钮 点击回调事件
            self!.spreadView.hideDownItemsAndPromptView(toHide: isSelected)
            self!.spreadView.openDelStatus(showDel: isSelected)
            self!.spreadView.isSortStatus = isSelected
            self!.spreadView.scrollToTop()
        }
        self.view.insertSubview(upView, aboveSubview: self.hScrollView)
        return upView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
    }
}

// MARK: - 对外公共方法
extension ZYColumnViewController {
    open func setSelectItem(title: String) {
        hScrollView.changeItemToSelected(title: title)
        delegate?.columnViewControllerSetTitle!(setTitle: title, index: arrayTitles.index(of: title)!)
    }
}

// MARK: - 初始化展开收拢按钮
extension ZYColumnViewController {
    fileprivate func setupSpreadButton() {
        spreadBtn = UIButton(type: UIButtonType.custom)
        // 包一层UIView 作为背景
        let bgView = UIView(frame: CGRect(x: kColumnScreenW - kColumnViewH, y: 0.0, width: kColumnViewH, height: kColumnViewH))
        // 右边展开按钮(按钮为正方形，边长为控制器view的高度)
        spreadBtn.frame = CGRect(x: 0 , y: 0 , width: bgView.frame.width, height: bgView.frame.height)
        bgView.backgroundColor = UIColor.white
        bgView.addSubview(spreadBtn)
        spreadBtn.backgroundColor = UIColor.clear
        spreadBtn.adjustsImageWhenHighlighted = false
        spreadBtn.setImage(UIImage(named: "column_spread.png"), for: UIControlState.normal)
        spreadBtn.addTarget(self, action: #selector(self.spreadBtnClick(spreadBtn:)), for: UIControlEvents.touchUpInside)       // 按钮点击事件监听
        view.addSubview(bgView)
    }
}

// MARK: - 控制方法
extension ZYColumnViewController {
    // MARK: - 展开收拢控制
    fileprivate func spreadOrFlod() {
        toSpread = !toSpread
        // cover 和 upPromptView通过参数交给内部scrollView控制显示隐藏
        spreadView.doSpreadOrFold(toSpread: toSpread, cover: cover, upPromptView: upPromptView)
        // 与子控件scrollView同步高度，保证子控件能够响应事件
        self.view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: toSpread ? kSpreadMaxH : kColumnViewH)
        // 旋转按钮layer图层
        transitionSpreadBtn(toSpread: toSpread)
        // 当编辑按钮在编辑状态时，收起时要复原
        if !toSpread && (upPromptView.editBtn?.isSelected)! {
            // 模拟用户点击了一下edit按钮
            upPromptView.editButtonClick(editBtn: upPromptView.editBtn!)
        }
        spreadView.isSortStatus = !toSpread
        self.tabBarController?.tabBar.isHidden = toSpread           //控制tabBar的隐藏或显示
    }
}

// MARK: - 点击事件处理
extension ZYColumnViewController {
    /// 展开收拢按钮点击事件
    @objc fileprivate func spreadBtnClick(spreadBtn : UIButton) {
        spreadOrFlod()
    }
    /// 旋转展开按钮
    fileprivate func transitionSpreadBtn(toSpread : Bool) {
        UIView.animate(withDuration: 0.2) { () -> Void in
            let angle = toSpread ? M_PI * 0.25 : -M_PI * 0.25
            self.spreadBtn.transform = self.spreadBtn.transform.rotated(by: CGFloat(angle))
        }
    }
}

//
//  ZYColumnSpreadView.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit
// 上面item点击的闭包
typealias upItemTapClosure = (_ item : ZYColumnItem) -> Void

// 上面item长按的闭包
typealias upItemLongPressClosure = () -> Void

// 收起spreadView闭包
typealias foldSpreadViewClosure = (_ upTitles : [String]  , _ downTitles : [String]) -> Void

class ZYColumnSpreadView: UIScrollView {
    
    // 上面的排序 标题 数组
    open var arrayUpTitles = [String]()
    // 下面的备选 标题 数组
    open var arrayDownTitles = [String]()
    // 固定不变的item个数
    open var fixedCount = 1
    // 标识当前是否排序状态
    open var isSortStatus = false
    // 上面item tap 的闭包
    open var tapClosure : upItemTapClosure?
    // 上面item长按闭包
    open var longPressClosure : upItemLongPressClosure?
    // 收起后的闭包
    open var flodClosure : foldSpreadViewClosure?
    
/************* 上面是对外属性 -----华丽分割线----- 下面是私有属性 ***************/
    
    // 存放up items的数组
    fileprivate var arrayUpItems = [ZYColumnItem!]()
    // 存放down items 的数组
    fileprivate var arrayDownItems = [ZYColumnItem!]()
    // 拖动view的下一个view的中心点  逐个赋值
    fileprivate var valuePoint = CGPoint(x: 0, y: 0)
    // 用于赋值
    fileprivate var nextPoint = CGPoint(x: 0, y: 0)
    // 下提示view
    fileprivate lazy var downPromptView : ZYColumnDownPromptView = {
        let upLastItem = self.arrayUpItems.last
        let downView = ZYColumnDownPromptView(frame: CGRect(x: 0, y: upLastItem!.frame.maxY + kColumnMarginH, width: ZYScreenWidth, height: kColumnViewH))
        downView.backgroundColor = UIColor.init(red: 240.0/255, green: 241.0/255, blue: 246.0/255, alpha: 1.0)
        return downView
    }()
}

// MARK: - 公共方法
extension ZYColumnSpreadView {
    /// 展开或者合拢
    open func doSpreadOrFold(toSpread : Bool , cover : UIView , upPromptView : UIView) {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        UIView.animate(withDuration: kSpreadDuration, animations: { [weak self]() -> Void in
            self?.frame = CGRect(x: 0, y: 0, width: kColumnViewW, height: toSpread ? kSpreadMaxH : 0.0)
        }) {(_) -> Void in
            upPromptView.isHidden = toSpread ? false : true
            cover.isHidden = toSpread ? false : true
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        }
        // 添加items
        if toSpread && arrayUpItems.isEmpty {
            addItems()
        }
        
        // 闭包回传值
        if self.flodClosure != nil && !toSpread {
            // 同步数组顺序
            arrayUpTitles.removeAll()
            arrayDownTitles.removeAll()
            for i in 0 ..< arrayUpItems.count {
                let item = arrayUpItems[i]!
                arrayUpTitles.append(item.title)
            }
            for i in 0 ..< arrayDownItems.count {
                let item = arrayDownItems[i]!
                arrayDownTitles.append(item.title)
            }
            self.flodClosure!(arrayUpTitles, arrayDownTitles)
        }
    }
    
    /// 隐藏或者显示下面的item和downPromptView 参数传false 则变为 显示
    open func hideDownItemsAndPromptView(toHide : Bool) {
        if arrayDownItems.isEmpty {     // 下面备选只要没有，一定不显示
            downPromptView.isHidden = true
        } else {
            downPromptView.isHidden = toHide
        }
        for i in 0 ..< arrayDownItems.count {
            let item : ZYColumnItem = arrayDownItems[i]
            item.isHidden = toHide
        }
    }
    
    /// 开启或者关闭排序按钮删除状态
    open func openDelStatus(showDel : Bool) {
        for i in 0 ..< arrayUpItems.count {
            let item : ZYColumnItem = arrayUpItems[i]
            if !item.isFixed {
                item.delBtn.isHidden = !showDel
            }
        }
    }
    
    /// 自动回滚到顶部
    open func scrollToTop() {
        var offect = self.contentOffset;
        offect.y = -self.contentInset.top;
        self.setContentOffset(offect, animated: false)
    }
}

// MARK: - 私有控制方法
extension ZYColumnSpreadView {
    // 通过index 计算出上面item的frame
    fileprivate func getUpFrameWithIndex(_ index : Int) -> CGRect {
        let x = CGFloat(index%kColumnLayoutCount) * (kColumnMarginW + kColumnItemW) + kColumnMarginW
        let y = CGFloat(index/kColumnLayoutCount) * (kColumnMarginH + kColumnItemH) + kColumnMarginH + kColumnViewH
        let frame = CGRect(x: x, y: y, width: kColumnItemW, height: kColumnItemH)
        return frame
    }
    // 从下面移动到上面
    fileprivate func addItemToUp(item : ZYColumnItem) {
        let lastItem = arrayUpItems.last
        // 判断下面的item是否需要下移
        if (lastItem!.tag + 1) % kColumnLayoutCount == 0 {
            moveItemsRowDownOrUp(isUp: false)
        }
        let newFrame = getUpFrameWithIndex(lastItem!.tag + 1)
        UIView.animate(withDuration: kSpreadDuration, animations: {
            item.frame = newFrame
        }) { (_) in
            self.reSetContentSize()
        }
    }
    // 将arrayDownItems 的items 整体下移或者上移一行 包含downPromptView
    private func moveItemsRowDownOrUp(isUp : Bool) {
        let rowH = isUp ? -(kColumnItemH + kColumnMarginH) : (kColumnItemH + kColumnMarginH)
        
        downPromptView.frame = CGRect(x: downPromptView.frame.origin.x, y: downPromptView.frame.origin.y+rowH, width: downPromptView.frame.width, height: downPromptView.frame.height)
        for i in 0 ..< arrayDownItems.count {
            let item = arrayDownItems[i]!
            item.frame = CGRect(x: item.frame.origin.x, y: item.frame.origin.y+rowH, width: item.frame.width, height: item.frame.height)
        }
    }
    // 从上面删除 item插入到下面
    fileprivate func removeItemFromUp(item : ZYColumnItem) {
        item.delBtn.isHidden = true
        item.isHidden = true
        reLayoutUpItemsWithAnimation()
        reLayoutDownItemsWithAnimation(withAnimate: false)
        let lastItem = arrayUpItems.last
        if (lastItem!.tag + 1)%kColumnLayoutCount == 0 {
            moveItemsRowDownOrUp(isUp: true)
        }
        reSetContentSize()
    }
    
    fileprivate func synchronizeItemsTag() {
        var x = 0
        for i in 0 ..< arrayUpItems.count {
            let item = arrayUpItems[i]!
            item.tag = i
            x += 1
        }
        
        var j = x
        for y in 0 ..< arrayDownItems.count {
            let item = arrayDownItems[y]!
            item.tag = j
            j += 1
        }
    }
    // 重新计算最新的contentSize
    private func reSetContentSize() {
        let lastItem = arrayDownItems.isEmpty ? arrayUpItems.last : arrayDownItems.last
        self.contentSize = CGSize(width: 0, height: lastItem!.frame.maxY + kColumnMarginH)
    }
    
    // 点击后 动态排序上面的item
    private func reLayoutUpItemsWithAnimation(){
        for i in 0 ..< arrayUpItems.count {
            let item = arrayUpItems[i]!
            let newFrame = getUpFrameWithIndex(item.tag)
            UIView.animate(withDuration: kSpreadDuration, animations: {
                item.frame = newFrame
            })
        }
    }
    // 点击后 动态排序下面的item
    fileprivate func reLayoutDownItemsWithAnimation(withAnimate : Bool) {
        for i in 0 ..< arrayDownItems.count {
            let item = arrayDownItems[i]!
            let x = CGFloat((item.tag - arrayUpItems.count) % kColumnLayoutCount) * (kColumnMarginW + kColumnItemW) + kColumnMarginW
            let y = CGFloat((item.tag - arrayUpItems.count) / kColumnLayoutCount) * (kColumnMarginH + kColumnItemH) + kColumnMarginH + downPromptView.frame.maxY
            if withAnimate {
                UIView.animate(withDuration: kSpreadDuration, animations: {
                    item.frame = CGRect(x: x, y: y, width: item.frame.width, height: item.frame.height)
                })
            } else {
                item.frame = CGRect(x: x, y: y, width: item.frame.width, height: item.frame.height)
            }
        }
    }
    
    // 删除图标点击闭包回调处理
    fileprivate func handleClosure (item : ZYColumnItem) {
        guard !item.isFixed else {
            return
        }
        // 从上面数组移除item 添加到下面数组
        arrayUpItems.remove(at: item.tag)
        arrayDownItems.insert(item, at: 0)
        synchronizeItemsTag()
        removeItemFromUp(item: item)
    }
}

// MARK: - 初始化 上 下 item 和 downPromptView
extension ZYColumnSpreadView {
    fileprivate func addItems(){
        // 添加上面 items
        
        for i in 0 ..< arrayUpTitles.count {
            let item = ZYColumnItem(frame: getUpFrameWithIndex(i))  // 通过公共方法计算frame
            item.title = arrayUpTitles[i]
            item.tag = i
            if i < fixedCount {
                item.isFixed = true
            }
            // 闭包回调
            item.delClosure = {
                [weak self](item : ZYColumnItem) -> Void in
                self!.handleClosure(item: item)
            }
            // 添加长按手势
            addLongPressGesture(item: item)
            
            // 添加tap手势
            addTapGesture(item: item)
            addSubview(item)
            arrayUpItems.append(item)
        }
        
        let upLastItem = arrayUpItems.last
        // 添加下提示view
        insertSubview(downPromptView, at: 0)
        guard !arrayDownTitles.isEmpty else {
            // 下面没有备选  直接算出spreadView contentSize
            self.contentSize = CGSize(width: 0, height: upLastItem!.frame.maxY + kColumnMarginH + downPromptView.frame.height)
            return
        }
        
        // 添加下排序items
        for i in 0 ..< arrayDownTitles.count {
            let x = CGFloat(i%kColumnLayoutCount) * (kColumnMarginW + kColumnItemW) + kColumnMarginW
            let y = CGFloat(i/kColumnLayoutCount) * (kColumnMarginH + kColumnItemH) + kColumnMarginH + downPromptView.frame.maxY
            let item = ZYColumnItem(frame: CGRect(x: x, y: y, width: kColumnItemW, height: kColumnItemH))
            item.title = arrayDownTitles[i]
            item.tag = i + arrayUpItems.count
            // 添加长按手势
            addLongPressGesture(item: item)
            // 添加tap手势
            addTapGesture(item: item)
            // 闭包回调
            item.delClosure = {
                [weak self](item : ZYColumnItem) -> Void in
                self!.handleClosure(item: item)
            }
            addSubview(item)
            arrayDownItems.append(item)
            if i == arrayDownTitles.count - 1 {
                let downLastItem = arrayDownItems.last
                self.contentSize = CGSize(width: 0, height: downLastItem!.frame.maxY + kColumnMarginH)
            }
        }
    }
}

// MARK: - 手势绑定 与手势处理
extension ZYColumnSpreadView {
    /// 为一个item绑定长按手势
    fileprivate func addLongPressGesture(item : ZYColumnItem) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.upItmesDidLongPress(longPress:)))
        item.addGestureRecognizer(longPressGesture)
    }
    /// item 长按手势处理
    @objc fileprivate func upItmesDidLongPress(longPress: UILongPressGestureRecognizer) {
        let item = longPress.view as! ZYColumnItem
        if item.isFixed {   // 固定的item 不做处理
            return
        }
        // 只响应上面的item的长按事件
        for i in 0 ..< arrayUpItems.count {
            let element = arrayUpItems[i]
            if element == item {
                handleLongPressGesture(item: item, longPress: longPress)
                return
            }
        }
    }
    
    /// 为一个item绑定tap手势
    fileprivate func addTapGesture(item : ZYColumnItem) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.itemDidTap(tapGesture:)))
        item.addGestureRecognizer(tapGesture)
    }
    // item tap事件处理
    @objc fileprivate func itemDidTap(tapGesture : UITapGestureRecognizer) {
        let item = tapGesture.view as! ZYColumnItem
        
        // 点击的是上面的item   回传值
        for i in 0 ..< arrayUpItems.count {
            let element = arrayUpItems[i]
            if element == item {
                if isSortStatus {
                    return
                }
                // 闭包传值
                if self.tapClosure != nil {
                    self.tapClosure!(item)
                }
                return
            }
        }
        // 点击的是下面的item   上移
        for i in 0 ..< arrayDownItems.count {
            let element = arrayDownItems[i]
            if element == item {
                addItemToUp(item: item)
                arrayDownItems.remove(at: item.tag - arrayUpItems.count)
                arrayUpItems.append(item)
                synchronizeItemsTag()
                reLayoutDownItemsWithAnimation(withAnimate: true)
                if arrayDownItems.isEmpty {         // 当最后一个item都上移了，下面的指示view 隐藏掉
                    downPromptView.isHidden = true
                }
                return
            }
        }
    }

    private func handleLongPressGesture(item : ZYColumnItem, longPress : UILongPressGestureRecognizer) {
        
        // 拿到当前的最新位置
        let recognizerPoint = longPress.location(in: self)
        
        switch longPress.state {
        case UIGestureRecognizerState.began:
            // 如果没有显示“删除”按钮，回传闭包，开启删除排序模式
            if !isSortStatus {
                if longPressClosure != nil {
                    longPressClosure!()
                }
            }
            
            // 禁用其他item的交互
            for i in 0 ..< arrayUpItems.count {
                let element = arrayUpItems[i]!
                if element != item {
                    element.isUserInteractionEnabled = false
                }
            }
            
            self.bringSubview(toFront: item)
            valuePoint = item.center
            item.scaleItemToLarge()
        case UIGestureRecognizerState.changed:
            // 更新长按item的位置
            item.center = recognizerPoint
            // 判断item的center是否移动到了其他item的位置上了
            for i in 0 ..< arrayUpItems.count {
                let element = arrayUpItems[i]!
                if element.frame.contains(item.center) && element != item && element.tag >= fixedCount {
                    // 开始位置索引
                    let fromIndex = item.tag
                    // 需要移动到的索引
                    let toIndex = element.tag
                    if toIndex > fromIndex {    // 往后移
                        // 把移动view的下一个view移动到记录的view的位置(valuePoint)，并把下一view的位置记为新的nextPoint，并把view的tag值-1,依次类推
                        UIView.animate(withDuration: kSpreadDuration, animations: {
                            for i in fromIndex + 1 ... toIndex {
                                let nextItem = self.viewWithTag(i) as! ZYColumnItem
                                self.nextPoint = nextItem.center
                                nextItem.center = self.valuePoint
                                self.valuePoint = self.nextPoint
                                nextItem.tag -= 1
                            }
                            item.tag = toIndex
                        })
                    } else {  // 往前移
                        // 把移动view的上一个view移动到记录的view的位置(valuePoint)，并把上一view的位置记为新的nextPoint，并把view的tag值+1,依次类推
                        UIView.animate(withDuration: kSpreadDuration, animations: {
                            for i in (toIndex ... fromIndex - 1).reversed(){
                                let nextItem = self.viewWithTag(i) as! ZYColumnItem
                                self.nextPoint = nextItem.center
                                nextItem.center = self.valuePoint
                                self.valuePoint = self.nextPoint
                                nextItem.tag += 1
                            }
                            item.tag = toIndex
                        })
                    }
                }
            }
        case UIGestureRecognizerState.ended:
            // 恢复其他item的交互
            for i in 0 ..< arrayUpItems.count {
                let element = arrayUpItems[i]!
                if element != item {
                    element.isUserInteractionEnabled = true
                }
            }
            // 还原item的大小
            item.scaleItemToOriginal()
            // 返回对应的中心点
            UIView.animate(withDuration: kSpreadDuration, animations: {
            })
            UIView.animate(withDuration: kSpreadDuration, animations: {
                item.center = self.valuePoint
                
                }, completion: { [weak self](_) in
                    // 同步数组
                    var temp = [ZYColumnItem!]()
                    for i in 0 ..< self!.arrayUpItems.count {
                        for j in 0 ..< self!.arrayUpItems.count {
                            let item = self!.arrayUpItems[j]!
                            if item.tag == i {
                                temp.append(item)
                                break
                            }
                        }
                    }
                    self!.arrayUpItems = temp
                })
        default:
            break
        }
    }
}

# ZYColumnViewController
仿网易新闻 频道选择器  支持swift3.0 简单易用 编译测试 XCode 8.0 XCode8.1

## 关于 ZYColumnViewController
* ZYColumnViewController是一款简单易用的轻量级频道选择控件，其UI界面参考网易新闻。但是我为用户留下大量的可定制DIY常量供使用者修改以满足各自项目的实际需求

## 支持版本
* 目前此控件尽支持swift3.0 已经在XCode8.0以及XCode8.1上进行了编译测试。需要OC版本或者支持swift2.3的可以issues我

## 如何使用
* 下载
    * 本控件暂时不支持cocoapods 需要下载到本地
* 集成和使用
    * 控件的内容存在于演示Demo中，将整个ZYColumnView 文件夹内的文件拖拽到你的项目中即可，无其他的任何依赖
    * ZYColumnViewController 力求最精简的API 让用户不需要关注太多 用户只需要按照Demo中的方法初始化，并且设置代理以后即可通过三个代理方法拿到你需要的一切回调
    * 如果你不需要下面的indicator指示条，可以进行简单处理，在配置文件中，将高度调整为0，或者将颜色设置为透明即可
* 你需要关注的
    * 面向你的是 ZYColumnViewController 里面的三个属性 以及三个代理方法
    * DIY 保证你的项目能达到你想要的效果，去ZYColumnConfig 里面去捣腾吧！

## 效果图

   ** gif 易挂 复制链接到浏览器看效果 http://www.code4app.com/data/attachment/forum/201610/30/141214iw12tueoo9ex9x2e.gif 

![image]("https://github.com/r9ronaldozhang/ZYColumnViewController/ZYColumnViewDemo/ZYColumnViewDemo/Introduce/column.gif")


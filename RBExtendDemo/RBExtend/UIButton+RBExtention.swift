//
//  UIButton+RBExtend.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/8/27.
//

import Foundation
import UIKit

// MARK: - 点击事件闭包与扩充点击范围
typealias BtnAction = (UIButton)->()
extension UIButton{
    private struct AssociatedKeys{
        static var actionKey = "actionKey"
    }
    
    @objc dynamic var action: BtnAction? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let action = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? BtnAction{
                return action
            }
            return nil
        }
    }
    
    /// 添加一个点击事件
    /// - Parameter action: 点击时执行的闭包
    @discardableResult // 消除未使用返回值时的警告
    func addClickAction(action:@escaping BtnAction) -> UIButton {
        return self.addEvent(event: .touchUpInside, action: action)
    }
    
    
    /// 添加一个事件
    /// - Parameters:
    ///   - event: 添加的事件
    ///   - action: 事件响应时执行的闭包
    @discardableResult //消除未使用返回值时的警告
    func addEvent(event:UIControl.Event, action:@escaping  BtnAction ) -> UIButton{
        self.action = action
        self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: event)
        return self
    }

    @objc func touchUpInSideBtnAction(btn: UIButton) {
         if let action = self.action {
             action(btn)
         }
    }
    
    
    @discardableResult //消除未使用返回值时的警告
    func addCountdown(time:Int, endAction:@escaping ()->()) -> UIButton {
        //倒计时时间
        var timeout = time
        let queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let _timer:DispatchSource = DispatchSource.makeTimerSource(flags: [], queue: queue) as! DispatchSource
        _timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1))
        //每秒执行
        _timer.setEventHandler(handler: { () -> Void in
            if(timeout<=0){ //倒计时结束，关闭
                _timer.cancel();
                DispatchQueue.main.sync(execute: { () -> Void in
                    self.isEnabled = true
                    endAction()
                })
            }else{//正在倒计时
                let seconds = timeout
                DispatchQueue.main.sync(execute: { () -> Void in
                    let str = String(describing: seconds)
                    let s = "秒"
                    self.titleLabel?.text = "\(str)\(s)"
                    self.setTitle("\(str)\(s)", for: .normal)
                    self.isEnabled = false
                })
                timeout -= 1;
            }
        })
        _timer.resume()
        return self
    }
    
    
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
        /// ...其他Key声明
    }
    /// 需要扩充的点击边距
    public var addClickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    // 重写系统方法修改点击区域
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if (addClickEdgeInsets != nil) {
            let x: CGFloat = -(addClickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(addClickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (addClickEdgeInsets?.left ?? 0) + (addClickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (addClickEdgeInsets?.top ?? 0) + (addClickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        }
        return bounds.contains(point)
    }
    
    
}


// MARK: - 图片文字位置
extension UIButton{
    
    enum RGButtonImagePosition {
        case top          //图片在上，文字在下，垂直居中对齐
        case bottom       //图片在下，文字在上，垂直居中对齐
        case left         //图片在左，文字在右，水平居中对齐
        case right        //图片在右，文字在左，水平居中对齐
    }
    
    
    /// - Description 设置Button图片的位置
    /// - Parameters:
    ///   - style: 图片位置
    ///   - spacing: 按钮图片与文字之间的间隔
    func imagePosition(style: RGButtonImagePosition, spacing: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }

    
}

// MARK: - 其他
extension UIButton {
    
    /// 根据文字创建按钮
    /// - Parameters:
    ///   - title: 文字
    ///   - font: 字体
    ///   - titleColor: 字体颜色
    /// - Returns: 按钮
    static func buildBtn(title: String, font: UIFont, titleColor: UIColor) -> UIButton {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = .clear
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = font
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        label.text = title
        label.textColor = titleColor
        label.font = font
        label.sizeToFit()
//        btn.addSubview(label)
        btn.width = label.width
        btn.height = label.height
        return btn

    }
}





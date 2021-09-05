//
//  UIView+RBExtention.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/8/27.
//

import Foundation
import UIKit


/// 缩进方向
enum Direction {
    case top
    case left
    case bottom
    case right
}

extension UIView {
    // MARK: - frame相关
    
    /// 尺寸
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = newValue
        }
    }
    
    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = newValue
        }
    }
    
    /// 横坐标
    var x: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }
    
    /// 纵坐标
    var y: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }
    
    /// 右端横坐标
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// 底端纵坐标
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(newValue) {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    /// 中心横坐标
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            center.x = newValue
        }
    }
    
    /// 中心纵坐标
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            center.y = newValue
        }
    }
    
    
    /// 右上角坐标
    var topRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y)
        }
    }
    
    /// 右下角坐标
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y - height)
        }
    }
    
    /// 左下角坐标
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x, y: newValue.y - height)
        }
    }
    
    /// 获取UIView对象某个方向缩进指定距离后的方形区域
    ///
    /// - Parameters:
    ///   - direction: 要缩进的方向
    ///   - distance: 缩进的距离
    /// - Returns: 得到的区域
    func cutRect(direction: Direction, distance: CGFloat) ->  CGRect {
        switch direction {
        case .top:
            return CGRect(x: 0, y: self.y + distance, width: self.width, height: self.height - distance)
        case .left:
            return CGRect(x: self.x + distance, y: 0, width: self.width - distance, height: self.height)
        case .right:
            return CGRect(x: 0, y: 0, width: self.width - distance, height: self.height)
        case .bottom:
            return CGRect(x: 0, y: 0, width: self.width, height: self.height - distance)
        }
    }
    
    // MARK: - 圆角边框
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radiu: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radiu: CGFloat) {
        if #available(iOS 11.0, *) {
            // iOS11:只需要带用这个系统方法就可以随意设置View的圆角了
            self.layer.cornerRadius = radiu
            self.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        }else {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radiu, height: radiu))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    
    /// 设置圆角
    /// - Parameter radiu: 圆角大小
    func corner(radiu: CGFloat) {
        
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radiu
            self.layer.maskedCorners = CACornerMask(rawValue: UIRectCorner.allCorners.rawValue)
        } else {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radiu, height: radiu))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    
    /// 圆角边框
    /// - Parameters:
    ///   - radiu: 圆角大小
    ///   - width: 边框宽
    ///   - color: 边框颜色
    func corner(radiu: CGFloat, width: CGFloat, color: UIColor) {
        self.layer.cornerRadius = radiu
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    
    // MARK: - 其他
    
    /// view生成图片
    func toImage() -> UIImage? {
        guard bounds.size.height > 0 && bounds.size.width > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
//        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
//        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)  // 高清截图
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
    }
    
}

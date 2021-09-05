//
//  UIColor+RBExtention.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/8/28.
//

import UIKit

// MARK: - 默认
extension UIColor {
    
    /// 默认文字颜色
    static var defaultTextColor: UIColor {
        return .hexColor(0x333333)
    }
    
    /// 默认背景颜色
    static var defaultBackgroundColor: UIColor {
        return .hexColor(0xEEEEEE)
    }
    
    /// 默认主题颜色
    static var defaultTheme: UIColor {
        return .hexColor(0xF05E58)
    }
    
    
    
}


// MARK: - 生成颜色
extension UIColor {
    
    
    
    /// 十六进制颜色
    /// - Parameter hexColor: 十六进制数
    /// - Returns: 颜色
    static func hexColor(_ hexColor: Int) -> UIColor! {
        let color = UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                            green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                            blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: 1.0)
        return color
    }
    
    
    /// 十六进制颜色
    /// - Parameters:
    ///   - hexColor: 十六进制数
    ///   - alpha: 透明度（0透明 1不透明）
    /// - Returns: 颜色
    static func hexColor(hexColor: Int, alpha: Float) -> UIColor! {
        return UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: CGFloat(alpha))
    }
    
}

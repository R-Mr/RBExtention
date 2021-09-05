//
//  UIImage+RBExtention.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/9/4.
//

import Foundation
import UIKit


extension UIImage {
    
    /// 根据颜色生成图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - width: 宽
    ///   - height: 高
    /// - Returns: 图片
    class func imageFromeColor(color: UIColor, width: CGFloat, height: CGFloat)-> UIImage{
        let rect = CGRect.init(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 根据颜色生成图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - viewSize: 大小
    /// - Returns: 图片
    class func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{

           let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
           UIGraphicsBeginImageContext(rect.size)
           let context: CGContext = UIGraphicsGetCurrentContext()!
           context.setFillColor(color.cgColor)
           context.fill(rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsGetCurrentContext()
           return image!

       }
    
    
    /// 二分压缩法
    /// - Parameter maxLength: 最大大小（压缩后小于这个值）
    /// - Returns: 压缩后的图片
     func compressImageMid(maxLength: Int) -> UIImage? {
            var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: 1) else { return nil }
            print("压缩前kb: \( Double((data.count)/1024))")
            if data.count < maxLength {
                return self
            }
            print("压缩前kb", data.count / 1024, "KB")
            var max: CGFloat = 1
            var min: CGFloat = 0
            for _ in 0..<6 {
                compression = (max + min) / 2
                data = self.jpegData(compressionQuality: compression)!
                if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                    min = compression
                } else if data.count > maxLength {
                    max = compression
                } else {
                    break
                }
            }
        
        print("压缩后kb", data.count / 1024, "KB")
        let resultImage: UIImage = UIImage(data: data)!
        return resultImage
     }
    
    
}

//
//  UILabel+RBExtention.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/9/4.
//

import Foundation
import UIKit


// MARK: - 添加点击事件或长按事件
typealias LabelAction = (UILabel)->()
typealias LongPressAction = (UIGestureRecognizer)->()
extension UILabel {
    private struct AssociatedKeys{
        static var actionKey = "actionKey"
        static var longPressKey = "longPressKey"

    }
    
    @objc dynamic var action: LabelAction? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let action = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? LabelAction{
                return action
            }
            return nil
        }
    }
    @objc dynamic var longPressAction: LongPressAction? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.longPressKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let action = objc_getAssociatedObject(self, &AssociatedKeys.longPressKey) as? LongPressAction{
                return action
            }
            return nil
        }
    }
    
    
    @objc func clickAction() {
        self.action?(self)
    }
    
    @objc func longPressGesture(sender:UIGestureRecognizer) {
        self.longPressAction?(sender);
    }
    
    
    /// 添加点击事件
    /// - Parameter action: 回调事件
    func addClickAction(action: @escaping LabelAction) {
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        self.action = action
        self.addGestureRecognizer(gesture)
    }
    
    /// 添加长按事件
    /// - Parameter action: 回调事件
    func addLongPressAction(action: @escaping LongPressAction) {
        self.isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        self.longPressAction = action
        self.addGestureRecognizer(gesture)
    }
    
    
}

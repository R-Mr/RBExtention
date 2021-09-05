//
//  ViewController.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/8/27.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "扩展demo"
        print("当前时间戳：\(Date.getNowTimeStamp())")
        
        let v = UIView(frame: CGRect(x: 10, y: 150, width: 200, height: 400))
        v.backgroundColor = .blue
        //        v.corner(byRoundingCorners: [.bottomLeft, .topLeft], radii: 20)
        v.corner(radiu: 10)
        self.view.addSubview(v)
        
        let iv = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.backgroundColor = .hexColor(0xFFFF00)
        
        let label = UILabel(frame: iv.bounds)
        label.text = "123"
        label.textColor = hexColor(0xff0000)
        iv.addSubview(label)
        
        
        iv.corner(radiu: 10, width: 1, color: .black)
        
        
        // view生成图片
        let image = iv.toImage() ?? UIImage()
        
        let btn = UIButton(frame: CGRect(x: 40, y: 40, width: 80, height: 80))
        btn.setImage(image, for: .normal)
        btn.setTitle("点我", for: .normal)
        btn.imagePosition(style: .bottom, spacing: 10) // 文字上图片下
        btn.backgroundColor = UIColor.hexColor(0x00FFFF)
        // 添加点击时间（闭包）
        btn.addClickAction {[weak self] (button) in
            print("按钮点击")
            guard let ima = screenSnapshot() else { return }
            self?.saveAction(ima: ima)
            //            UIImageWriteToSavedPhotosAlbum(ima, self, nil, nil)
            
        }
        // 扩充点击区域
        btn.addClickEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        v.addSubview(btn)
        
        
        print("当前时间戳（秒）：" + String.getNowTimeStamp())
        print("当前时间戳（毫秒）：" + String.getNowTimeMilliStamp())
        print("当前时间：" + String.getNowTimeString(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        print("当前时间2：" + String.getNowTimeStamp().getTimeString(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        print("当前时间3：" + String.getNowTimeMilliStamp().getMilliTimeString(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        
        // Do any additional setup after loading the view.
    }
    
    func saveAction(ima: UIImage) {
        UIImageWriteToSavedPhotosAlbum(ima, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil{
            
            print("保存失败")
            
        }else{
            
            print("保存成功")
            
        }
        
    }
}


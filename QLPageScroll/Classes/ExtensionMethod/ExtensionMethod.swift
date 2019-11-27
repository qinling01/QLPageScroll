//
//  ExtensionMethod.swift
//  QLPageScroll_Example
//
//  Created by Mac on 2019/11/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension UIView {
    
    var left: CGFloat{
        get{
            return self.frame.origin.x
        } set{
            self.frame.origin.x = newValue
        }
    }
    
    var right: CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
    
    var top: CGFloat{
        get{
            return self.frame.origin.y
        }set{
            self.frame.origin.y = newValue
        }
    }
    
    var bottom: CGFloat{
        return self.frame.origin.y + self.frame.size.height
    }
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var centerX: CGFloat {
        return self.frame.origin.x + self.frame.size.width/2.0
    }
    
    var centerY: CGFloat {
        return self.frame.origin.y + self.frame.size.height/2.0
    }
    
    func setx(_ x:CGFloat) {
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func sety(_ y:CGFloat) {
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func setCenterX(_ x:CGFloat) {
        var center = self.center
        center.x = x
        self.center = center
    }
    
    func setCenterY(_ y:CGFloat) {
        var center = self.center
        center.y = y
        self.center = center
    }
    
    func setWidth(_ width:CGFloat) {
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(_ height:CGFloat) {
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
}

public extension UIColor {
    /// 16进制 转 RGBA
    ///
    /// - Parameters:
    ///   - rgb: 16进制色值
    ///   - alpha: 透明度
    /// - Returns: UIColor
    class func rgbaColorFromHex(_ rgb:Int, alpha:CGFloat) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16))/255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8))/255.0,
                       blue: ((CGFloat)(rgb & 0xFF))/255.0,
                       alpha: alpha)
    }
    
    /// 16进制 转 RGB
    ///
    /// - Parameter rgb: 16进制色值
    /// - Returns: UIColor
    class func rgbColorFromHex(_ rgb:Int) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16))/255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8))/255.0,
                       blue: ((CGFloat)(rgb & 0xFF))/255.0,
                       alpha: 1.0)
    }
    
    /// 样式 #5B5B5B
    ///
    /// - Parameters:
    ///   - color: 传入#5B5B5B格式的字符串
    ///   - alpha: 传入透明度
    ///   - defalutColor: 失败默认色
    /// - Returns: 颜色
    class func rgbColorFromHexStr(_ color: String, alpha: CGFloat = 1, defalutColor: UIColor = .clear) -> UIColor {
        if color.isEmpty {
            return defalutColor
        }
        var cString = color.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cString.count == 0 {
            return defalutColor
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count < 6 && cString.count != 6 {
            return defalutColor
        }
        
        var value: String = ""
        if cString.hasPrefix("0x") {
            value = cString
        }else{
            value = "0x\(cString)"
        }
        let scanner = Scanner(string:value)
        
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return defalutColor
        }
    }
}

//
//  Define.swift
//  SchoolApp
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 jyl. All rights reserved.
//

import UIKit

public let Swindow = UIApplication.shared.delegate?.window
public let Sbounds = UIScreen.main.bounds
public let Swidth = UIScreen.main.bounds.width
public let Sheight = UIScreen.main.bounds.height
/// 除去导航栏页面高度
public let SheightWithin = Sheight-SafeAreaNavHeight
/// 导航栏高度
public let SafeAreaNavHeight: CGFloat = (Sheight == 812.0 ? 88.0 : 64.0)
/// 状态栏高度
public let SafeAreaNavHeightTop: CGFloat = (Sheight == 812.0 ? 44.0 : 20.0)
/// 底部距边高度（iPhoneX）
public let SafeAreaBottomHeight: CGFloat = (Sheight == 812.0 ? 34.0 : 0.0)
/// 工具栏高度
public let SafeAreaTabBarHeight: CGFloat = (Sheight == 812.0 ? 83.0 : 49.0)
/// 是否iPoneX
public let IsIPhoneX: Bool = (Sheight == 812.0 ? true : false)

//封装的日志输出功能（T表示不指定日志信息参数类型）
public func printL(_ items: Any..., methodName: String = #function, lineNumber: Int = #line) {
    //s文件名、方法、行号、打印信息
    #if DEBUG
    print(NSDate().addingTimeInterval(28800)," | ","\(methodName) | 行:\(lineNumber) | 日志:",items,"\n");
    #endif
}

/// 常规色级Sec
public let TextColorSec: UIColor = UIColor.rgbColorFromHex(0x333333)
/// 常规蓝色
public let BuleCorlor: UIColor = UIColor.rgbColorFromHex(0x2396F5)
/// 默认主题背景色
public let ThemeBackGroundColor: UIColor = UIColor.rgbColorFromHex(0xFFFFFF)
/// 默认主题标题字体色
public let ThemeTitleColor: UIColor = UIColor.rgbColorFromHex(0x333333)
/// 默认主题工具栏字体选中色
public let ThemeTabarTitleHColor: UIColor = UIColor.rgbColorFromHex(0x333333)

/// Identifier
public let CFBundleIdentifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
/// 版本号
public let CFBundleVersionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/// 设备的IDFV
public let IDFV = UIDevice.current.identifierForVendor?.uuidString



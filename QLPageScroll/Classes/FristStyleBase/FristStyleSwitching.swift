//
//  FristStyleSwitching.swift
//  xuedao
//
//  Created by Mac on 2019/5/20.
//  Copyright © 2019年 Mac. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol FristStyleSwitchingDelegate: NSObjectProtocol {
    /// 点击控件切换
    ///
    /// - Parameter selectIndex: 选中下标
    @objc optional func interactiveHeaderTouchSelected(_ selectIndex: Int)
}

class FristStyleSwitching: UIView {
    private var tabButtonsArray: Array<FristStyleButton> = []
    private var title: [String] = []
    private let tagMin: Int = 10
    private var select_index: Int = 0 //选中下标 默认从0开始
    private let selectFontSize: CGFloat = 32 //选中字体
    private let normalFontSize: CGFloat = 20 //常规字体
    private let min_alpha: CGFloat = 0.8 //最小透明度
    private let max_alpha: CGFloat = 1.0 //最大透明度
    private var animationInterval: TimeInterval = 0.3
    
    /// 字体颜色
    internal var textColor: UIColor = TextColorSec {
        didSet {
            self.setTextColor()
        }
    }
    
    weak var delegate: FristStyleSwitchingDelegate?
    init(titles: [String]) {
        super.init(frame: CGRect.zero)
        self.title = titles
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        self.tabButtonsArray.removeAll()
        
        var leftConstraint = self.snp.left
        for index in 0 ..< self.title.count {
            let tab = FristStyleButton()
            tab.textColor = self.textColor
            tab.tag = index + tagMin
            tab.setMinMaxFontSize(minFontSize: Float(self.normalFontSize))
            tab.setTitle(title: self.title[index])
            self.addSubview(tab)
            
            self.addConstraintForButton(button: tab, leftSlibling: leftConstraint)
            leftConstraint = tab.snp.right
            
            tab.addTarget(self, action: #selector(lbTouchBegen(_:)), for: UIControl.Event.touchUpInside)
            self.tabButtonsArray.append(tab)
        }
        
        self.addSubview(cursorv)
        cursorv.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.tabButtonsArray[0].snp.centerX)
            make.bottom.equalTo(0)
            make.width.equalTo(16)
            make.height.equalTo(3)
        }
    }
    
    /// 设置主题颜色
    private func setTextColor(){
        for index in 0 ..< self.title.count {
            let tab = self.viewWithTag(index + tagMin) as! FristStyleButton
            tab.textColor = self.textColor
        }
        
        let defaultC = UIColor.rgbColorFromHexStr("#FFFFFF", defalutColor: ThemeBackGroundColor)
        if self.textColor == ThemeTitleColor && defaultC == ThemeBackGroundColor{
            self.cursorv.backgroundColor = BuleCorlor
        }else{
            self.cursorv.backgroundColor = self.textColor
        }
    }
    
    /// 下标光标
    internal lazy var cursorv : UIView = {
        let cursor = UIView()
        //设置标题栏的颜色
        cursor.backgroundColor = BuleCorlor
        cursor.layer.cornerRadius = 2
        cursor.layer.masksToBounds = true
        return cursor
    }()
    
    private func addConstraintForButton(button: FristStyleButton, leftSlibling: ConstraintItem) {
        let leftOffset = (button.tag - tagMin == 1) ? 10 : 12
        var font = UIFont.systemFont(ofSize: CGFloat(self.normalFontSize))
        
        if self.select_index == button.tag - tagMin {
            //选中位置
            button.isSelected = true
            button.setSelected(selected: true, fontSize: Float(self.selectFontSize))
            font = UIFont.systemFont(ofSize: CGFloat(self.selectFontSize))
        }
        
        let size = FristStyleButton.size(text: button.title, font: font)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(leftSlibling).offset(leftOffset)
            make.bottom.equalTo(0);
            make.width.equalTo(size.width);
            make.height.equalTo(self.snp.height);
        }
    }
    
    @objc private func lbTouchBegen(_ sender: FristStyleButton){
        
        self.updateUI(index: sender.tag - tagMin)
        
        if delegate?.responds(to: #selector(FristStyleSwitchingDelegate.interactiveHeaderTouchSelected(_:))) == true {
            self.delegate?.interactiveHeaderTouchSelected!(self.select_index)
        }
    }
    
    ///点击刷新布局
    private func updateUI(index: Int) {
        if index == self.select_index {
            return;
        }
        let currentButton = self.tabButtonsArray[index]
        let lastSelectButton = self.tabButtonsArray[self.select_index]
        currentButton.setSelected(selected: true, fontSize: Float(self.selectFontSize))
        lastSelectButton.setSelected(selected: false, fontSize: Float(self.normalFontSize))
        
        currentButton.snp.updateConstraints { (make) in
            make.width.equalTo(FristStyleButton.size(text: currentButton.title, font: UIFont.systemFont(ofSize: self.selectFontSize)).width)
        }
        
        lastSelectButton.snp.updateConstraints { (make) in
            make.width.equalTo(FristStyleButton.size(text: lastSelectButton.title, font: UIFont.systemFont(ofSize: self.normalFontSize)).width)
        }
        
        cursorv.snp.remakeConstraints { (make) in
            make.centerX.equalTo(currentButton.snp.centerX)
            make.bottom.equalTo(0)
            make.width.equalTo(16)
            make.height.equalTo(3)
        }
        
        UIView.animate(withDuration: self.animationInterval) {
            self.layoutIfNeeded()
        }
        self.select_index = index
    }
    
    ///滑动画刷新布局
    public func updateUI(progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        
        let progresFont = (self.selectFontSize - self.normalFontSize) * progress
        //原目标
        let sourceButton = self.tabButtonsArray[sourceIndex]
        //现目标
        let targetButton = self.tabButtonsArray[targetIndex]
        
        let sourceFont =  self.selectFontSize - CGFloat(progresFont)
        let targetFont =  self.normalFontSize + CGFloat(progresFont)
        
        //        printL("++++selectFont+++",selectFont)
        //        printL("++++normalFont+++",normalFont)
        
        sourceButton.setSelected(selected: false, fontSize: Float(sourceFont))
        
        targetButton.setSelected(selected: true, fontSize: Float(targetFont))
        
        sourceButton.snp.updateConstraints { (make) in
            make.width.equalTo(FristStyleButton.size(text: sourceButton.title, font: UIFont.systemFont(ofSize: sourceFont)).width)
        }
        
        targetButton.snp.updateConstraints { (make) in
            make.width.equalTo(FristStyleButton.size(text: targetButton.title, font: UIFont.systemFont(ofSize: targetFont)).width)
        }
        
        let moveTotalX = (targetButton.centerX - sourceButton.centerX) * progress
        
        cursorv.snp.remakeConstraints { (make) in
            make.centerX.equalTo(sourceButton.snp.centerX).offset(moveTotalX)
            make.bottom.equalTo(0)
            make.width.equalTo(16)
            make.height.equalTo(3)
        }
        
        self.select_index = targetIndex
    }
    
}

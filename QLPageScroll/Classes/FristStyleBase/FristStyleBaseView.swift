//
//  FristStyleBaseView.swift
//  LiGongDX
//
//  Created by Mac on 2019/7/15.
//  Copyright © 2019 QinL. All rights reserved.
//

import UIKit
import SnapKit

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

@objc public protocol FristStyleBaseViewDelegate: NSObjectProtocol {
    /// 当前页下标
    ///
    /// - Parameter page: 下标
    @objc optional func reloadCurrentPage(_ page: Int)
}

open class FristStyleBaseView: UIView {
    private var fristView: FristStyleView!
    
    /// 背景色
    open var backGroundColor: UIColor = UIColor.white {
        didSet {
            if fristView != nil{
                fristView.backGroundColor = backGroundColor
            }
        }
    }
    
    /// 字体色
    open var textColor: UIColor = TextColorSec {
        didSet {
            if fristView != nil{
                fristView.textColor = textColor
            }
        }
    }
    
    open weak var delegate: FristStyleBaseViewDelegate?
    
    public init(titles: [String], childVs: [UIView]) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Swidth, height: Sheight)))
        
        fristView = FristStyleView.init(titles: titles, childVs: childVs)
        fristView.delegate = self
        self.addSubview(fristView)
        fristView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     private func commonInit(){
        
    }
}

// MARK: - FristStyleViewDelegate
extension FristStyleBaseView: FristStyleViewDelegate {
    public func reloadCurrentPage(_ page: Int) {
        if self.delegate?.responds(to: #selector(FristStyleViewDelegate.reloadCurrentPage(_:))) == true {
            self.delegate?.reloadCurrentPage?(page)
        }
    }
}


@objc public protocol FristStyleViewDelegate: NSObjectProtocol {
    /// 当前页下标
    ///
    /// - Parameter page: 下标
    @objc optional func reloadCurrentPage(_ page: Int)
}

class FristStyleView: UIView {
    internal var switching: FristStyleSwitching!
    private var scorllview: UIScrollView!
    ////是否禁止滚动,防止设置contentOffset时继续执行scrollViewDidScroll协议
    private var isForbidScrollDelegate: Bool = false
    //滚动开始时的偏移值
    private var startOffsetX : CGFloat = 0
    
    private var lined: UIImageView!
    private var title: [String] = []
    private var childVs: [UIView] = []
    internal let navHeight: CGFloat = SafeAreaNavHeight + 16
    
    /// 背景色
    var backGroundColor: UIColor = UIColor.white {
        didSet {
            self.setThemeColor()
        }
    }
    
    /// 字体色
    var textColor: UIColor = TextColorSec {
        didSet {
            self.setThemeColor()
        }
    }
    
    weak var delegate: FristStyleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(titles: [String], childVs: [UIView]) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Swidth, height: Sheight)))
        self.title = titles
        self.childVs = childVs
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        self.backgroundColor = UIColor.clear
        switching = FristStyleSwitching( titles: self.title)
        switching.delegate = self
        self.addSubview(switching)
        switching.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaNavHeightTop)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(navHeight-SafeAreaNavHeightTop)
        }
        
        lined = self.establishLine(CGRect.zero)
        self.addSubview(lined)
        lined.snp.makeConstraints { (make) in
            make.top.equalTo(self.switching.snp.bottom)
            make.left.equalTo(self.switching.snp.left)
            make.right.equalTo(self.switching.snp.right)
            make.height.equalTo(1)
        }

        self.scorllview = UIScrollView()
        self.scorllview.showsHorizontalScrollIndicator = false
        self.scorllview.isPagingEnabled = true
        self.scorllview.delegate = self
        self.scorllview.bounces = false
        self.scorllview.backgroundColor = UIColor.clear
        self.addSubview(scorllview)
        self.scorllview.snp.makeConstraints { (make) in
            make.top.equalTo(lined.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        var leftConstraint = self.scorllview.snp.left
        for eview in childVs {
            self.scorllview.addSubview(eview)

            addConstraintForView(eview: eview, leftSlibling: leftConstraint)
            leftConstraint = eview.snp.right
        }
        
        self.layoutIfNeeded()
    }
    
    private func addConstraintForView(eview: UIView, leftSlibling: ConstraintItem) {
        eview.snp.makeConstraints { (make) in
            make.left.equalTo(leftSlibling)
            make.top.width.height.equalTo(self.scorllview)
        }
    }
    
    /// 设置主题
    private func setThemeColor() {
        self.backgroundColor = self.backGroundColor
        self.switching.textColor = self.textColor
    }
    
    //创建line
    private func establishLine(_ frame:CGRect = CGRect.zero) -> UIImageView {
        let imgview = UIImageView.init(frame: frame)
        imgview.alpha = 0.5
        imgview.image = UIImage(named: "lineh", in: BundleUtil.getCurrentBundle(), compatibleWith: nil)
        return imgview
    }
    
    /// 开始拖动
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.scorllview {
            //禁止在滚动
            isForbidScrollDelegate = false
            
            // 当前的索引
            startOffsetX = scrollView.contentOffset.x
        }
    }
    
    /// 滚动中代理
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scorllview {
            // 0.判断是否是点击事件
            if isForbidScrollDelegate { return }
            
            // 1.定义获取需要的数据
            var progress : CGFloat = 0
            var sourceIndex : Int = 0
            var targetIndex : Int = 0
            
            // 2.判断是左滑还是右滑
            let currentOffsetX = scrollView.contentOffset.x
            let scrollViewW = scrollView.bounds.width
            if currentOffsetX > startOffsetX { // 左滑
                // 1.计算progress
                progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
                
                // 2.计算sourceIndex
                sourceIndex = Int(currentOffsetX / scrollViewW)
                
                // 3.计算targetIndex
                targetIndex = sourceIndex + 1
                if targetIndex >= childVs.count {
                    targetIndex = childVs.count - 1
                }
                
                // 4.如果完全划过去
                if currentOffsetX - startOffsetX == scrollViewW {
                    progress = 1
                    targetIndex = sourceIndex
                }
            } else { // 右滑
                // 1.计算progress
                progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
                
                // 2.计算targetIndex
                targetIndex = Int(currentOffsetX / scrollViewW)
                
                // 3.计算sourceIndex
                sourceIndex = targetIndex + 1
                if sourceIndex >= childVs.count {
                    sourceIndex = childVs.count - 1
                }
            }
            // 3.将progress/sourceIndex/targetIndex传递给titleView
            self.scrollview(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        }
    }
    
    /// 滚动结束且弹簧效果结束
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scorllview {
            isForbidScrollDelegate = false
        }
        
        //当前页数
        let currentPage: Int = Int(scrollView.contentOffset.x/self.scorllview.width)
        if self.delegate?.responds(to: #selector(FristStyleBaseViewDelegate.reloadCurrentPage(_:))) == true {
            self.delegate?.reloadCurrentPage?(currentPage)
        }
    }
    
    /// 结束拖拽
    ///
    /// - Parameters:
    ///   - scrollView: UIScrollView
    ///   - decelerate: 是否结束弹簧效果
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollview(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        //异常处理，两个下标相同时不执行
        if sourceIndex == targetIndex { return }
        self.switching.updateUI(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scorllview.contentSize = CGSize(width: self.scorllview.width * CGFloat(title.count), height: self.scorllview.height)
    }
    
}

// MARK: - UIScrollViewDelegate
extension FristStyleView: UIScrollViewDelegate {
    
}

// MARK: - FristStyleSwitchingDelegate
extension FristStyleView: FristStyleSwitchingDelegate {
    func interactiveHeaderTouchSelected(_ selectIndex: Int) {
        // 更新视图下标
        if self.delegate?.responds(to: #selector(FristStyleViewDelegate.reloadCurrentPage(_:))) == true {
            self.delegate?.reloadCurrentPage?(selectIndex)
        }
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(selectIndex) * self.scorllview.frame.width
        self.scorllview.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

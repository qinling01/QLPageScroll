//
//  FristStyleButton.swift
//  LiGongDX
//
//  Created by Mac on 2019/7/15.
//  Copyright © 2019 QinL. All rights reserved.
//

import UIKit
import SnapKit

class FristStyleButton: UIControl {
    private var tabTitleImageView: UIImageView!
    private var fontSize: Float = 20
    private var blFont: Float = 0
    private var animationInterval: TimeInterval = 0.3
    
    internal var title = " "
    
    internal var textColor: UIColor = TextColorSec {
        didSet {
            self.setTitle(title: self.title)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTabTitleImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTabTitleImageView() {
        self.tabTitleImageView = UIImageView()
        self.tabTitleImageView.contentMode = .scaleAspectFit
        self.addSubview(self.tabTitleImageView)
        
        self.tabTitleImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0);
            make.bottom.equalTo(-12);
            make.height.equalTo(self.fontSize);
        }
    }
    
    public func setMinMaxFontSize(minFontSize: Float) {
        self.fontSize = minFontSize
        self.blFont = minFontSize + 3
    }
    
    public func setTitle(title: String) {
        self.title = title;
        self.tabTitleImageView.image = self.txtSwapImage(text: self.title);
    }
    
    public func setSelected(selected: Bool, fontSize: Float) {
        self.fontSize = fontSize
        self.updateTabImage(height: fontSize)
        
        if selected != self.isSelected {
            UIView.animate(withDuration: self.animationInterval) {
                self.layoutIfNeeded()
            }
        }
        self.isSelected = selected
    }
    
    private func updateTabImage(height: Float) {
        self.tabTitleImageView.image = self.txtSwapImage(text: self.title);
        self.tabTitleImageView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    private func txtSwapImage(text: String) -> UIImage {
        let textFont = self.fontSize <= self.blFont ? UIFont.systemFont(ofSize: CGFloat(self.fontSize)) : UIFont.boldSystemFont(ofSize: CGFloat(self.fontSize))
        let textSize = FristStyleButton.size(text: text, font: textFont)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byCharWrapping
        style.lineSpacing = 0
        //字符间距
        style.paragraphSpacing = 2
        
        let attributes = [NSAttributedString.Key.font : textFont,
                          NSAttributedString.Key.foregroundColor : self.textColor,
                          NSAttributedString.Key.backgroundColor : UIColor.clear,
                          NSAttributedString.Key.paragraphStyle : style]
        
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0);
        text.draw(in: CGRect(origin: CGPoint.zero, size: textSize), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }
    
    class func size(text: String ,font: UIFont) -> CGSize {
        let constraintRect = CGSize()
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.size
    }
}

//
//  ViewController.swift
//  QLPageScroll
//
//  Created by 秦灵 on 11/26/2019.
//  Copyright (c) 2019 秦灵. All rights reserved.
//

import UIKit
import QLPageScroll
import SnapKit

class ViewController: UIViewController {
    
    internal var fristNavStyle: FristStyleBaseView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fristNavStyle = FristStyleBaseView.init(titles: ["办事", "资讯"], childVs: [workOview, informationTview])
        fristNavStyle.delegate = self
        fristNavStyle.backGroundColor = ThemeBackGroundColor
        fristNavStyle.textColor = ThemeTitleColor
        self.view.addSubview(fristNavStyle)
        fristNavStyle.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    /// 办事
    private lazy var workOview: UIView = {
        let work = UIView()
        work.backgroundColor = UIColor.white
        return work
    }()
    
    /// 资讯
    private lazy var informationTview: UIView = {
        let tableT = UIView()
        tableT.backgroundColor = UIColor.white
        return tableT
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - FristStyleBaseViewDelegate
extension ViewController: FristStyleBaseViewDelegate {
    func reloadCurrentPage(_ page: Int) {
        
    }
}


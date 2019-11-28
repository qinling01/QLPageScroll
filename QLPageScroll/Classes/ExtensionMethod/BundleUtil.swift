//
//  BundleUtil.swift
//  FBSnapshotTestCase
//
//  Created by Mac on 2019/11/28.
//

import UIKit
import Foundation

class BundleUtil {
    static func getCurrentBundle() -> Bundle{
        
        let podBundle = Bundle(for: FristStyleBaseView.self)
        
        let bundleURL = podBundle.url(forResource: "QLPageScrollImg", withExtension: "bundle")
        
        if bundleURL == nil {
            if podBundle.bundlePath.contains("QLPageScrollImg.framework") {   // carthage
                return podBundle
            }
        }
        
        if bundleURL != nil {
            let bundle = Bundle(url: bundleURL!)!
            return bundle
        }else{
            return Bundle.main
        }
    }
}

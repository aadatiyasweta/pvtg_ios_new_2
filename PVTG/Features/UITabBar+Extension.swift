//
//  UITabBar+Extension.swift
//  PVTG
//
//  Created by kashish on 04/02/22.
//  Copyright © 2022 ShubhamMacmini. All rights reserved.
//

import UIKit

extension UITabBar {
    func addBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = "●"
            tabItem.badgeColor = .clear
            tabItem.setBadgeTextAttributes([.font: UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor(red: 210.0/255.0, green: 162.0/255.0, blue: 117.0/255.0, alpha: 1.0)], for: .normal)
        }
    }
    func removeBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
    
 }

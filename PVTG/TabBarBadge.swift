//
//  TabBarBadge.swift
//  PVTG
//
//  Created by kashish on 08/02/22.
//  Copyright © 2022 ShubhamMacmini. All rights reserved.
//

import UIKit

extension UITabBarController {
  func setBadges(badgeValues: [Int]) {
    var labelExistsForIndex = [Bool]()

    for _ in badgeValues {
      labelExistsForIndex.append(false)
    }

    for view in tabBar.subviews {
      if let badgeView = view as? PGTabBadge {
        let index = badgeView.tag

        if badgeValues[index] == 0 {
          badgeView.removeFromSuperview()
        }

        labelExistsForIndex[index] = true
        badgeView.text = String(badgeValues[index])
      }
    }

    for i in 0 ... labelExistsForIndex.count - 1 where !labelExistsForIndex[i] && badgeValues[i] > 0 {
      addBadge(
        index: i,
        value: badgeValues[i],
        color: UIColor(red: 4 / 255, green: 110 / 255, blue: 188 / 255, alpha: 1),
        font: UIFont(name: "Helvetica-Light", size: 11)!
      )
    }
  }

  func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
   let badgeView = PGTabBadge()

    guard let tabBarItems = tabBar.items else { return }
    let itemPosition = CGFloat(index + 1)
    let itemWidth: CGFloat = tabBar.frame.width / CGFloat(tabBarItems.count)

    let bgColor = color

    let xOffset: CGFloat = 12
    let yOffset: CGFloat = -9


    badgeView.frame.size = CGSize(width: 17, height: 17)
    badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth / 2) + xOffset, y: 20 + yOffset)
    badgeView.layer.cornerRadius = badgeView.bounds.width / 2
    badgeView.clipsToBounds = true
    badgeView.border(width: 0.5, color: .darkGray)
    badgeView.textColor = UIColor.black
    badgeView.textAlignment = .center
    badgeView.font = font
    badgeView.text = String(value)
    badgeView.backgroundColor = UIColor(red: 244.0/255, green: 204.0/255, blue: 204.0/255, alpha: 1.0)
//   badgeView.backgroundColor = bgColor.cg
    badgeView.tag = index
    tabBar.addSubview(badgeView)
  }
 
 func removeBadgeSubview(){
  for subview in tabBar.subviews{
   if subview is PGTabBadge {
    subview.removeFromSuperview()
          }
 }
}
}

class PGTabBadge: UILabel {}

//
//  TabBarControllerViewController.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.tabBarVc = self
    }

    //MARK: - TAB BAR STYLE
    // Set before the tab bar is first drawn, so the icons and colours are right from the first launch
    private func setupTabBarAppearance() {
        let normal = UIColor().coloWithHexString(hex: "#9c9a9a")
        let selected = UIColor().coloWithHexString(hex: "#05d9bd")
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        self.tabBar.items?[0].image = UIImage(named: "homeGrey")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "eventGrey")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "event")?.withRenderingMode(.alwaysOriginal)
//        self.tabBar.items?[2].image = UIImage(named: "guideGrey")?.withRenderingMode(.alwaysOriginal)
//        self.tabBar.items?[2].selectedImage = UIImage(named: "guide")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "moreGreen")?.withRenderingMode(.alwaysOriginal)
    }

    //MARK: - HELPERS
    func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }

}

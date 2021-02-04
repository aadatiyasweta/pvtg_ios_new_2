//
//  TabBarControllerViewController.swift
//  PVTG
//
//  Created by Test Machine on 22/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
           

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.items?[0].selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
              
              self.tabBar.items?[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#05d9bd")], for: .selected)
              self.tabBar.items?[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#9c9a9a")], for: .normal)
                self.tabBar.items?[0].image = UIImage(named: "homeGrey")?.withRenderingMode(.alwaysOriginal)
              
                self.tabBar.items?[1].selectedImage = UIImage(named: "event")?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[1].image = UIImage(named: "eventGrey")?.withRenderingMode(.alwaysOriginal)
              self.tabBar.items?[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#05d9bd")], for: .selected)
              self.tabBar.items?[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#9c9a9a")], for: .normal)
              
                self.tabBar.items?[2].selectedImage = UIImage(named: "guide")?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[2].image = UIImage(named: "guideGrey")?.withRenderingMode(.alwaysOriginal)
              self.tabBar.items?[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#05d9bd")], for: .selected)
              self.tabBar.items?[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#9c9a9a")], for: .normal)
              
              self.tabBar.items?[3].image = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
               self.tabBar.items?[3].selectedImage = UIImage(named: "moreGreen")?.withRenderingMode(.alwaysOriginal)
              self.tabBar.items?[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#05d9bd")], for: .selected)
              self.tabBar.items?[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor().coloWithHexString(hex: "#9c9a9a")], for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

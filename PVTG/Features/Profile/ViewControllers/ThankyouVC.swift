//
//  ThankyouVC.swift
//  PVTG
//
//  Created by Test Machine on 06/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class ThankyouVC: BaseViewController {
 
    //MARK: - Outlets
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    var name = ""
    var points = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pointsLbl.text = R.string.localizable.yourSessionHasBeen(self.points)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         renderTheColorOfImage()
    }
    
    //MARK: - METHOD TO SET RENDER COLOR OF IMAGE
    func renderTheColorOfImage() {
        let myImage = UIImage(named: "minimalLeft2X")
        let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
        self.btnBack.setImage(tintableImage, for: .normal)
        self.btnBack.tintColor = .white
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnTapBooking(_ sender: UIButton) {
         appDelegate.tabBarVc?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: true)
    }
}

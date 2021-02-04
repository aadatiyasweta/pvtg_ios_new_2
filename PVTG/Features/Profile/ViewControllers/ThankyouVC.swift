//
//  ThankyouVC.swift
//  PVTG
//
//  Created by Test Machine on 06/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit

class ThankyouVC: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         renderTheColorOfImage()
    }
    func renderTheColorOfImage() {
               let myImage = UIImage(named: "minimalLeft2X")
               let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
        self.btnBack.setImage(tintableImage, for: .normal)
        self.btnBack.tintColor = .white
       }
    
    @IBAction func btnTapBooking(_ sender: UIButton) {
    }
    
}

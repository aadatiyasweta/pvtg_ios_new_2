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
    @IBOutlet weak var titleLbl: UILabel!
    var name = ""
    var points = ""
    var isFromReschedule = false

    // Swiping back would return to the payment screen
    override var allowsSwipeBack: Bool {
        return false
    }

    @IBOutlet weak var viwBookingBtn: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromReschedule == true {
            self.pointsLbl.text = "Your booking has been rescheduled."
            self.titleLbl.text = "Reschedule Complete"
        }else{
            self.pointsLbl.text = R.string.localizable.yourSessionHasBeen(self.points)
        }
        
        self.view.bringSubviewToFront(viwBookingBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         renderTheColorOfImage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    //MARK: - METHOD TO SET RENDER COLOR OF IMAGE
    func renderTheColorOfImage() {
        let myImage = UIImage(named: "minimalLeft2X")
        let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
        self.btnBack.setImage(tintableImage, for: .normal)
        self.btnBack.tintColor = .white
    }
    
    
    @IBAction func tappedBtnbokking(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let tabBarVc = appDelegate.tabBarVc {
            tabBarVc.selectedIndex = 1
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            print("appDelegate or tabBarVc is nil")
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnTapBooking(_ sender: UIButton) {
//         appDelegate.tabBarVc?.selectedIndex = 1
//        self.navigationController?.popToRootViewController(animated: true)
    }
}

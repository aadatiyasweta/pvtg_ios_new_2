//
//  ReminderView.swift
//  PVTG
//
//  Created by Techugo on 30/09/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//
protocol ReminderViewYesProtocol : AnyObject{
    func getYesCallback(id : String)
}
import Foundation
import UIKit

class ReminderView : UIView{
  
    @IBOutlet weak var titleLbl: UILabel!
    weak var delegate : ReminderViewYesProtocol?
    var id = ""

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    class func initWith(frame: CGRect)->ReminderView? {
        let view = Bundle.main.loadNibNamed("ReminderView", owner: self, options: nil)?[0] as? ReminderView
        view?.frame = frame
        return view
    }
    
    @IBAction func yesBtnTao(_ sender: UIButton) {
        self.delegate?.getYesCallback(id: id)
        self.removeFromSuperview()
       
    }
    @IBAction func noBtnTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }

}

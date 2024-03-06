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
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    weak var delegate : ReminderViewYesProtocol?
    var id = ""
    var callBackClosure : ((Bool)->())?
    var title = ""
    var heading = ""
    var btnText1 = ""
    var btnText2 = ""
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    class func initWith(frame: CGRect)->ReminderView? {
        let view = Bundle.main.loadNibNamed("ReminderView", owner: self, options: nil)?[0] as? ReminderView
        view?.frame = frame
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLbl.text = title
        self.headingLabel.text = heading
        self.yesButton.setTitle(self.btnText1, for: .normal)
        self.noButton.setTitle(self.btnText2, for: .normal)
    }
    
    @IBAction func yesBtnTao(_ sender: UIButton) {
        self.delegate?.getYesCallback(id: id)
        self.callBackClosure?(true)
        self.removeFromSuperview()
       
    }
    @IBAction func noBtnTap(_ sender: UIButton) {
        self.callBackClosure?(false)
        self.removeFromSuperview()
    }

}

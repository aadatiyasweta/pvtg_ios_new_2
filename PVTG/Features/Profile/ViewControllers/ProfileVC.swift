//
//  ProfileVC.swift
//  PVTG
//
//  Created by Test Machine on 05/01/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import UIKit
import MarqueeLabel

class ProfileVC: BaseViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var imgBg: UIImageView!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPVTGPoints: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblMobNo: UILabel!
    
    @IBOutlet weak var lblEmailAdd: UILabel!
    
    @IBOutlet weak var colectionVwinterest: UICollectionView!{
        didSet {
            colectionVwinterest.dataSource = self
            colectionVwinterest.delegate = self
            colectionVwinterest.register(ProfileInterestCell.nib(), forCellWithReuseIdentifier: ProfileInterestCell.ident)
        }
    }
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    private var vm = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTheColorOfImage()
        vm.delegate = self
       // setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadApi()
    }
    
    func renderTheColorOfImage() {
          DispatchQueue.main.async {
            self.imgUser.layer.cornerRadius = 10
            self.imgUser.image = #imageLiteral(resourceName: "more")
              let myImage = UIImage(named: "logoWhite")
              let tintableImage = myImage?.withRenderingMode(.alwaysTemplate)
              self.imageLogo.image = tintableImage
              self.imageLogo.tintColor = UIColor().coloWithHexString(hex: "#05d9bd")
          }
      }
    

   //MARK:- IBActions
    
    @IBAction func EditprofileTap(_ sender: UIButton) {
        let vc = EditProfileVC.instance()
        vc.userDta = self.vm.model?.user_profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func EditInterestTap(_ sender: UIButton) {
        let vc = TransformerExampleViewController.instance()
        vc.controllerId = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.model?.selected_category?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInterestCell.ident, for: indexPath) as? ProfileInterestCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.leadingConstraint.constant = 18
            cell.traillingconstarint.constant = 0
        } else if indexPath.row == (self.vm.model?.selected_category!.count)! - 1{
            cell.leadingConstraint.constant = 0
            cell.traillingconstarint.constant = 18

        }else{
            cell.leadingConstraint.constant = 0
            cell.traillingconstarint.constant = 0
        }
        cell.setData(interest: self.vm.model?.selected_category?[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
             return CGSize(width: 118, height: 105)
        }
        else if indexPath.row == (self.vm.model?.selected_category!.count)! - 1{
             return CGSize(width: 118, height: 105)
        }
        return CGSize(width: 100, height: 105)
    }
    
}

extension ProfileVC: UpdateTheProfile {
    func updateProfile() {
        guard let data = self.vm.model else {return}
        self.lblPVTGPoints.text = (data.user_profile?.total_point ?? "") + " Purevibes pts"
        self.lblName.text = data.user_profile?.name ?? ""
        self.lblEmailAdd.text = data.user_profile?.email ?? ""
        loadImage(data.user_profile?.user_image ?? "", self.imgUser, activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        if let phone = data.user_profile?.phone {
            self.lblMobNo.text = "\(phone)"
            
        }
        self.colectionVwinterest.reloadData()
       // self.lblAddress.text = data.user_profile.ad
    }
    
    
}

extension ProfileVC {
    private  func loadApi() {
           if let userid = SaveToDefaults().getUserId() {
            self.vm.getUserProfileApi(user_id: userid)
           }
       }
    
    private func setData() {
        guard let data = self.vm.getDataFromLocal() else {return}
        loadImage(data.user_profile?.user_image ?? "", self.imgUser, activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        SaveToDefaults().setProfilePic(value: data.user_profile?.user_image ?? "")
        self.lblPVTGPoints.text = (data.user_profile?.total_point ?? "") + "Purevibes pts"
        if let address = SaveToDefaults().getformattedAddress() {
              self.lblAddress.text = address

        }
        self.lblName.text = data.user_profile?.name ?? ""
        self.lblEmailAdd.text = data.user_profile?.email ?? ""
        self.lblMobNo.text = "\(data.user_profile?.phone ?? "")"
    }
}


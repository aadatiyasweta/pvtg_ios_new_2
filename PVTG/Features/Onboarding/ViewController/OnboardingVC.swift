//
//  OnboardingVC.swift
//  NPNGUserApp
//
//  Created by Techugo on 11/08/20.
//  Copyright © 2020 Techugo. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController {
    //    MARK:- IBOutlets
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var imgOnboarding: UIImageView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw2: UIView!
    
    //    MARK:- Variables
    let headingArr = [R.string.localizable.pointAccumulation(),R.string.localizable.earnUseRewardss(), R.string.localizable.rewards()]
    var titleArr = ["" , "" , R.string.localizable.onbaordingThirdMsg()]
    //R.string.localizable.onbaordingFourthMsg(),R.string.localizable.onbaordingFiftMsg(),R.string.localizable.onbaordingThirdMsg()
    let imageArr : [UIImage] = [#imageLiteral(resourceName: "group3-2"), #imageLiteral(resourceName: "group3-1"), #imageLiteral(resourceName: "group3")]
    var index : Int = 0
    var controllerId = 0
    let onboarding1 = PaperOnboarding()
    let button1 = UIButton()
    var vm = OnboardingVm()
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.vm.delegate = self
        self.vm.hitOnboaridngApi()
       // forCreateCustomOnboarding()
        self.imgOnboarding.image = #imageLiteral(resourceName: "rectangle-3")
        self.vw1.backgroundColor = .white
        self.vw2.backgroundColor = .white
        self.vw3.backgroundColor = .white
        self.vw2.alpha = 0.5
        self.vw3.alpha = 0.5
       
        // self.mainPageControl.defersCurrentPageDisplay = false
        self.collecView.delegate = self
        self.collecView.dataSource = self
        SaveToDefaults().setIsNew(isNew: true)
        self.collecView.register(OnboardingFirstPointsCell.nib(), forCellWithReuseIdentifier: OnboardingFirstPointsCell.ident)
        self.collecView.register(OnboardingSecondCell.nib(), forCellWithReuseIdentifier: OnboardingSecondCell.ident)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // self.collecView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func buttonClicked() {
        print("Button Clicked")
        if index == self.titleArr.count - 1{
            
            print(index)
            if controllerId == 1{
                self.navigationController?.popViewController(animated: true)
            } else {
                let vc = LoginVC.instance()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            index += 1
            if controllerId == 1{
                self.navigationController?.popViewController(animated: true)
            } else {
                let vc = LoginVC.instance()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(index)
            //            self.collecView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    @IBAction func skipBtnTap(_ sender: UIButton) {
        
        if controllerId == 1{
            self.navigationController?.popViewController(animated: true)
        } else {
            let vc = LoginVC.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        if index == 2{
//
//
//        }else{
//            index += 1
//            self.collecView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: true)
//        }
        
    }
    
}
extension OnboardingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.vm.model?.point_accumulation == nil{
            return 1
        }
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingFirstPointsCell", for: indexPath) as! OnboardingFirstPointsCell
            cell.bindData(model: self.vm.model?.point_accumulation)
            return cell
        }
     
        else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingSecondCell", for: indexPath) as! OnboardingSecondCell
            cell.bindRewardData(model: self.vm.model?.rewards ?? [])
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingSecondCell", for: indexPath) as! OnboardingSecondCell
            cell.iconImageView.image = UIImage.init(named: "group3")
            cell.backgroundColor = #colorLiteral(red: 0.3817746043, green: 0.4064786732, blue: 0.8502063155, alpha: 1)
            cell.titleLbl.text = R.string.localizable.rewards()
            var str = [String]()
            for val in 0..<(self.vm.model?.earn_reward!.count)!{
                str.append("\(val+1). \(self.vm.model?.earn_reward?[val].message ?? "")")
            }
            cell.descLbl.text = str.joined(separator: "\n\n")
            return cell
        }
    
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.index = Int(collectionView.contentOffset.x/collectionView.frame.width)
        if index == 0{
            self.vw1.alpha = 1
            self.vw2.alpha = 0.5
            self.vw3.alpha = 0.5
            self.imgOnboarding.image = #imageLiteral(resourceName: "rectangle-3")
        }else if index == 1{
            self.vw1.alpha = 0.5
            self.vw2.alpha = 1
            self.vw3.alpha = 0.5
            self.imgOnboarding.image = #imageLiteral(resourceName: "rectangle3Copy")
        }else{
            self.vw1.alpha = 0.5
            self.vw2.alpha = 0.5
            self.vw3.alpha = 1
            self.imgOnboarding.image = #imageLiteral(resourceName: "rectangle-3")
        }
      
        if index == 2 {
            if controllerId == 1{
                btnSkip.setTitle(R.string.localizable.done(), for: .normal)
            } else {
                btnSkip.setTitle(R.string.localizable.getStarted(), for: .normal)
            }
        } else {
         if(index == 0){
          btnSkip.setTitle("", for: .normal)
         }else {
          btnSkip.setTitle(R.string.localizable.done(), for: .normal)
         }
        }
    }
}



//extension OnboardingVC: PaperOnboardingDataSource, PaperOnboardingDelegate {
//    func onboardingItem(at index: Int) -> OnboardingItemInfo {
//        return [
//
//            OnboardingItemInfo(informationImage: imageArr[0],
//                               title: headingArr[0],
//                               description: titleArr[0],
//                               pageIcon: imageArr[0],
//                               color: UIColor().coloWithHexString(hex: "#6168D9"),
//                               titleColor: UIColor.white,
//                               descriptionColor: UIColor.white,
//                               titleFont: UIFont(name: Fonts.semiBold.rawValue, size: 18) ?? UIFont(),
//                               descriptionFont: UIFont(name: Fonts.regular.rawValue, size: 13) ?? UIFont()),
//
//            OnboardingItemInfo(informationImage: imageArr[1],
//                               title: headingArr[1],
//                               description: titleArr[1],
//                               pageIcon: imageArr[1],
//                               color: UIColor().coloWithHexString(hex: "#05d9bd"),
//                               titleColor: UIColor.white,
//                               descriptionColor: UIColor.white,
//                               titleFont: UIFont(name: Fonts.semiBold.rawValue, size: 18) ?? UIFont(),
//                               descriptionFont: UIFont(name: Fonts.regular.rawValue, size: 14) ?? UIFont()),
//
//            OnboardingItemInfo(informationImage: imageArr[2],
//                               title: headingArr[2],
//                               description: titleArr[2],
//                               pageIcon: imageArr[2],
//                               color: UIColor().coloWithHexString(hex: "#6168D9"),
//                               titleColor: UIColor.white,
//                               descriptionColor: UIColor.white,
//                               titleFont: UIFont(name: Fonts.semiBold.rawValue, size: 18) ?? UIFont(),
//                               descriptionFont: UIFont(name: Fonts.regular.rawValue, size: 14) ?? UIFont()),
////            OnboardingItemInfo(informationImage: imageArr[3],
////                               title: headingArr[3],
////                               description: titleArr[3],
////                               pageIcon: imageArr[3],
////                               color: UIColor().coloWithHexString(hex: "#6168D9"),
////                               titleColor: UIColor.white,
////                               descriptionColor: UIColor.white,
////                               titleFont: UIFont(name: Fonts.semiBold.rawValue, size: 22) ?? UIFont(),
////                               descriptionFont: UIFont(name: Fonts.regular.rawValue, size: 14) ?? UIFont()),
////            OnboardingItemInfo(informationImage: imageArr[4],
////                               title: headingArr[4],
////                               description: titleArr[4],
////                               pageIcon: imageArr[4],
////                               color: UIColor().coloWithHexString(hex: "#05d9bd"),
////                               titleColor: UIColor.white,
////                               descriptionColor: UIColor.white,
////                               titleFont: UIFont(name: Fonts.semiBold.rawValue, size: 22) ?? UIFont(),
////                               descriptionFont: UIFont(name: Fonts.regular.rawValue, size: 14) ?? UIFont())
//        ][index]
//    }
//
//    func onboardingItemsCount() -> Int {
//        return titleArr.count
//    }
//
//    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
//        // config labels
//        item.titleLabel?.numberOfLines = 0
//        item.titleLabel?.lineBreakMode = .byWordWrapping
//        // item.descriptionLabel?.textAlignment = .left
//        item.titleCenterConstraint?.constant = 5
//        // allow for full width images
//        // allow for full width images
//        if !(imageArr[index].images != nil) {
//            if let imageSize = item.imageView?.image?.size {
//                if index == self.titleArr.count-1 {
//                    if controllerId == 1{
//                        button1.setTitle(R.string.localizable.done(), for: .normal)
//                    } else {
//                        button1.setTitle(R.string.localizable.getStarted(), for: .normal)
//                    }
//                } else {
//                    self.index += 1
//                    button1.setTitle(R.string.localizable.skip(), for: .normal)
//                }
//
//                if (index == 0) && (UIScreen.main.nativeBounds.height == 1334){
//                    item.informationImageWidthConstraint?.constant = imageSize.width
//                    item.informationImageHeightConstraint?.constant = 360
//                }else {
//                item.informationImageWidthConstraint?.constant = imageSize.width
//                item.informationImageHeightConstraint?.constant = imageSize.height
//                }
//                item.setNeedsUpdateConstraints()
//            }
//        }
//
//    }
//}
extension OnboardingVC : getOnboardingResponse{
    func getOnboardingData() {
    
        
        self.collecView.reloadData()
       // self.forCreateCustomOnboarding()
    }
}

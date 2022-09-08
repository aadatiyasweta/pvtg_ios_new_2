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
   
    //MARK: - Outlets
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var imgOnboarding: UIImageView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw2: UIView!
    
   //MARK: - Properties
    let headingArr = [R.string.localizable.pointAccumulation(),R.string.localizable.earnUseRewardss(), R.string.localizable.rewards()]
    var titleArr = ["" , "" , R.string.localizable.onbaordingThirdMsg()]
    let imageArr : [UIImage] = [#imageLiteral(resourceName: "group3-2"), #imageLiteral(resourceName: "group3-1"), #imageLiteral(resourceName: "group3")]
    var index : Int = 0
    var controllerId = 0
    let onboarding1 = PaperOnboarding()
    let button1 = UIButton()
    var vm = OnboardingVm()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.delegate = self
        self.vm.hitOnboaridngApi()
        self.imgOnboarding.image = #imageLiteral(resourceName: "rectangle-3")
        self.vw1.backgroundColor = .white
        self.vw2.backgroundColor = .white
        self.vw3.backgroundColor = .white
        self.vw2.alpha = 0.5
        self.vw3.alpha = 0.5
        self.collecView.delegate = self
        self.collecView.dataSource = self
        SaveToDefaults().setIsNew(isNew: true)
        self.collecView.register(OnboardingFirstPointsCell.nib(), forCellWithReuseIdentifier: OnboardingFirstPointsCell.ident)
        self.collecView.register(OnboardingSecondCell.nib(), forCellWithReuseIdentifier: OnboardingSecondCell.ident)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        }
    }
    
    
    @IBAction func skipBtnTap(_ sender: UIButton) {
        if controllerId == 1{
            self.navigationController?.popViewController(animated: true)
        } else {
            let vc = LoginVC.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - COLLECTION VIEW DELEGATES
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

//MARK: - CUSTOM DELEGATE
extension OnboardingVC : getOnboardingResponse{
    func getOnboardingData() {
        self.collecView.reloadData()
    }
}

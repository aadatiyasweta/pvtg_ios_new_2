//
//  InterestVC.swift
//  PVTG
//
//  Created by Test Machine on 24/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

/*import UIKit

class InterestVC: BaseViewController {
    
    @IBOutlet weak var vwToManageShape: UIView!{
        didSet {
            self.vwToManageShape.layer.cornerRadius = self.vwToManageShape.frame.height/2
        }
    }
    @IBOutlet weak var VwBottomconstrain: NSLayoutConstraint!
    @IBOutlet weak var vwContaininterestCount: UIView!
    @IBOutlet weak var lblInterestCopunt: UILabel!
    @IBOutlet weak var pagerVw: FSPagerView!{
        didSet {
            pagerVw.dataSource = self
            pagerVw.delegate = self
           // self.pagerVw.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerVw.register(InterCell.nib(), forCellWithReuseIdentifier: InterCell.ident)
        }
    }
    
    @IBOutlet weak var colectionCategryVw: UICollectionView!{
        didSet {
            colectionCategryVw.delegate = self
            
            colectionCategryVw.dataSource = self
        }
    }
    
    //MARK:Variables
    let images = [#imageLiteral(resourceName: "vectorSmartObject-30"), #imageLiteral(resourceName: "vectorSmartObject-20"), #imageLiteral(resourceName: "vectorSmartObject-10"), #imageLiteral(resourceName: "vectorSmartObject00")]
    let name = ["Sports", "Movie", "Travel", "Music"]
    var vm = InterestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        onApiCompletion()
        pagerVw.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        colectionCategryVw.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.ident)
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        self.vwContaininterestCount.layer.cornerRadius = self.vwContaininterestCount.frame.height/2
        if #available(iOS 13, *) {
            self.VwBottomconstrain.constant = self.vwContaininterestCount.frame.height/2 + 35
        } else {
            self.VwBottomconstrain.constant = self.vwContaininterestCount.frame.height/2
        }
    }
    
    
}

extension InterestVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerVw: FSPagerView) -> Int {
        return self.images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerVw.dequeueReusableCell(withReuseIdentifier: InterCell.ident, at: index) as! InterCell
//        if let img = self.vm.model?.result?[index].category_image, let name = self.vm.model?.result?[index].category_name {
//            loadImage(img, cell.imageView ?? UIImageView(), activity: nil, defaultImage: nil)
//            cell.textLabel?.text = name
//        }
//        cell.imageView?.frame.size = CGSize(width: 45, height: 45)
//        cell.imageView?.image = images[index]
//        cell.textLabel?.text = name[index]
//        cell.textLabel?.textColor = .black
//        cell.imageView?.contentMode = .scaleAspectFit
//        cell.imageView?.clipsToBounds = true
//        cell.backgroundColor = .black
        cell.img.image = images[index]
        cell.lbl.text = name[index]
        return cell
        
    }
    
    
}

extension InterestVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.ident, for: indexPath)
        return cell
    }
    
    
}

extension InterestVC {
    
    private func onApiCompletion() {
        self.pagerVw.transformer = FSPagerViewTransformer(type:.ferrisWheel)
        self.pagerVw.itemSize = CGSize(width: 100, height: 100)
        self.pagerVw.interitemSpacing = 0
        self.pagerVw.decelerationDistance = FSPagerView.automaticDistance
        self.pagerVw.reloadData()
        //self.pagerVw.listCount = self.vm.model?.result?.count ?? 0
    }
    
    func loadApi() {
        if let userid = SaveToDefaults().getUserId() {
            self.vm.getAllCategoryApi(user_id: userid)
        }
    }
}

extension InterestVC: LoadingCategory {
    func reloaddata() {
        onApiCompletion()
        self.pagerVw.reloadInputViews()
        if let catgryCount = self.vm.model?.total_Category {
            self.lblInterestCopunt.text = "\(catgryCount)"
        }
    }
    
    
}
*/

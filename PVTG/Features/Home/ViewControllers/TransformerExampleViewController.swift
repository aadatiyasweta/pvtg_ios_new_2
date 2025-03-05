import UIKit

var checkCollectionView = 1

class TransformerExampleViewController: BaseViewController,FSPagerViewDataSource,FSPagerViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var colectionVw: UICollectionView!{
        didSet {
            colectionVw.delegate = self
            colectionVw.dataSource = self
            colectionVw.register(AllCategoryCell.nib(), forCellWithReuseIdentifier: AllCategoryCell.ident)
        }
    }
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var btnWidthConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblNoInterest: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK: - Properties
    var selectedCtaegory = -1
    var selectedCategoryArr = [SelectedInterest]()
    var vm = InterestViewModel()
    var controllerId = 0
    var topIndex = 0
    var bottomIndex = 0
    var mealType:String = "Breakfast"
    var level:String = "Medium"
    var closureOK : (String,String) -> () = { _,_  in}
    var fromSignUp = false
    var getCategoryId = [String]()
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    
    
    fileprivate var typeIndexx = 0 {
        didSet {
            // let type = self.transformerTypes[typeIndex]
            
            self.pagerView.transformer = FSPagerViewTransformer(type:.ferrisWheel)
            self.pagerView.interitemSpacing = 0
            self.pagerView.itemSize = CGSize(width: 100, height: 120)
            pagerView.isInfinite = true
            self.pagerView.decelerationDistance = FSPagerView.automaticDistance
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.dataSource = self
            pagerView.delegate = self
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndexx = 0
        }
    }
    
    @IBOutlet weak var vwContainCount: UIView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        vm.delegate = self
        guard let userid = SaveToDefaults().getUserId() else {return}
        vm.getAllCategoryApi(user_id: userid)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.scrollTo),
            name: Notification.Name("scrollTo"),
            object: nil)
        backBtn.isHidden = self.fromSignUp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.typeIndexx = topIndex
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundedTop(targetView: vw1, desiredCurve: vw1.frame.size.height/2)
        roundedTop(targetView: vw2, desiredCurve: vw2.frame.size.height/2)
        //vwContainCount.layer.cornerRadius = 87.5
        roundedTop(targetView: vwContainCount, desiredCurve: 87.5)
        if self.fromSignUp {
            self.btnWidthConstrain.constant = 0
        } else {
            self.btnWidthConstrain.constant = 35
        }
        let index = self.typeIndexx
        self.typeIndexx = index // Manually trigger didSet
        colectionVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func roundedTop(targetView:UIView?, desiredCurve:CGFloat?) {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x:bounds.origin.x - offset / 2,y: bounds.origin.y, width : bounds.size.width + offset, height :bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        targetView!.layer.mask = maskLayer
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func doneTap(_ sender: UIButton) {
        guard let userid = SaveToDefaults().getUserId() else {return}
        var id = [String]()
        for val in self.selectedCategoryArr{
            id.append(val.category_id)
        }
        self.vm.userSelectedCategoryApi(user_id: userid, selected_category: id.joined(separator: ","))
    }
    
    // MARK: -  FSPAGERVIEWDATASOURCE
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.vm.model?.result?.count ?? 0
    }
    
    @objc private func scrollTo(notification: NSNotification){
        print("Scroll to")
        pagerView.deselectItem(at: self.typeIndexx, animated: true)
        pagerView.scrollToItem(at: self.typeIndexx, animated: true)
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        loadImage(self.vm.model?.result?[index].category_image ?? "", cell.imageView ?? UIImageView(), activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = self.vm.model?.result?[index].category_name
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.backgroundColor = .clear
        cell.pageViewTag = pagerView.tag
        //cell.selectedBackgroundView?.layer.backgroundColor = UIColor.blue.cgColor
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        print("didHighlightItemAt",index)
        let id = self.vm.model?.result?[index].category_id ?? ""
        if !selectedCategoryArr.contains(where: {$0.category_id == id}){
            self.selectedCategoryArr.append(SelectedInterest(category_image: self.vm.model?.result?[index].category_image ?? "", category_name: self.vm.model?.result?[index].category_name ?? "", category_id: self.vm.model?.result?[index].category_id ?? ""))
            
            colectionVw.reloadData()
            colectionVw.scrollToItem(at: IndexPath.init(row: selectedCategoryArr.count-1, section: 0), at: .bottom, animated: true)
            // self.lblCount.text = "\(selectedCategoryArr.count)"
        }else{
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if index == self.selectedCtaegory {
            print("yes")
        } else {
            print("no")
        }
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

//MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE
extension TransformerExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint(self.selectedCategoryArr.count)
        return self.selectedCategoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllCategoryCell.ident, for: indexPath) as? AllCategoryCell else { return UICollectionViewCell() }
        cell.lblInterest.numberOfLines = 2
        loadImage(self.selectedCategoryArr[indexPath.row].category_image,  cell.imgInterest, activity: nil, defaultImage: #imageLiteral(resourceName: "more"))
        cell.lblInterest.text = self.selectedCategoryArr[indexPath.row].category_name
        cell.tag = indexPath.row
        cell.closure = { index in
            debugPrint(index)
            if index == indexPath.row {
                self.selectedCategoryArr.remove(at: indexPath.row)
                self.colectionVw.reloadData()
                self.colectionVw.scrollToItem(at: IndexPath.init(row: self.selectedCategoryArr.count-1, section: 0), at: .centeredHorizontally, animated: true)
                // self.lblCount.text = "\(self.selectedCategoryArr.count)"
                if self.selectedCategoryArr.count == 0{
                    self.lblNoInterest.isHidden = false
                    self.btnDone.setTitle(R.string.localizable.skip(), for: .normal)
                }else{
                    self.lblNoInterest.isHidden = true
                    self.btnDone.setTitle(R.string.localizable.done(), for: .normal)
                }
            }
        }
        if self.selectedCategoryArr.count == 0{
            self.lblNoInterest.isHidden = false
            self.btnDone.setTitle(R.string.localizable.skip(), for: .normal)
        }else{
            self.lblNoInterest.isHidden = true
            self.btnDone.setTitle(R.string.localizable.done(), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH/3-10, height: 180)
    }
}

//MARK: - LOADING CATEGORY DELEGATE
extension TransformerExampleViewController: LoadingCategory {
    func fillSelectedArray() {
        if self.fromSignUp{
            let vc = TabBarControllerViewController.instance()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func reloaddata() {
        lblCount.text = "\(self.vm.model?.result?.count ?? 0)"
//        for i in 0..<(self.vm.model?.result?.count ?? 0){
//            self.getCategoryId.append(self.vm.model?.result?[i].category_id ?? "")
//        }
//        let intCategoryId = getCategoryId.compactMap { Int($0) }
//        print(intCategoryId)
        
        for val in self.vm.model?.selected_category ?? []{
            self.selectedCategoryArr.append(SelectedInterest(category_image: val.category_image ?? "", category_name: val.category_name ?? "", category_id: val.category_id ?? ""))
        }
        if self.selectedCategoryArr.count == 0{
            //skip
            self.lblNoInterest.isHidden = false
            self.btnDone.setTitle(R.string.localizable.skip(), for: .normal)
        }else{
            self.lblNoInterest.isHidden = true
            self.btnDone.setTitle(R.string.localizable.done(), for: .normal)
        }
        colectionVw.reloadData()
//        var index = -2
//        if index == self.selectedCtaegory {
//            print("yes")
//        } else {
//            print("no")
//        }
//        pagerView.deselectItem(at: index, animated: true)
        pagerView.reloadData()
    }
}

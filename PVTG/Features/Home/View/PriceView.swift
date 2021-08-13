//
//  PriceView.swift
//  PVTG
//
//  Created by Techugo on 13/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//

import Foundation
import UIKit
import RangeSeekSlider

class PriceView : UIView{
    
    @IBOutlet weak var seekView: RangeSeekSlider!
    @IBOutlet weak var topViewCons: NSLayoutConstraint!
    
    @IBOutlet weak var collView: UICollectionView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    class func initWith(frame: CGRect)->PriceView? {
        let view = Bundle.main.loadNibNamed("PriceView", owner: self, options: nil)?[0] as? PriceView
        view?.frame = frame
        view?.setUp()
        return view
    }
    
    @IBAction func rightBtnTao(_ sender: UIButton) {
    }
    func setUp(){
        self.collView.register(LineMeasureCell.nib(), forCellWithReuseIdentifier: LineMeasureCell.ident)
    
        seekView.colorBetweenHandles = #colorLiteral(red: 0, green: 0.8693377376, blue: 0.7882207632, alpha: 1)
        seekView.tintColor = .white
        seekView.minLabelColor = .white
        seekView.maxLabelColor = .white
        self.collView.delegate = self
        self.collView.dataSource = self
    }
}
extension PriceView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 55
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineMeasureCell", for: indexPath) as! LineMeasureCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 5, height: collView.frame.size.height)
    }
}

//
//  PriceView.swift
//  PVTG
//
//  Created by Techugo on 13/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//
protocol getPriceSliderValues : class{
    func slidermaxMinValue(min : Int , max : Int)
}
import Foundation
import UIKit
import RangeSeekSlider

class PriceView : UIView{
    
    @IBOutlet weak var seekView: RangeSeekSlider!
    
    @IBOutlet weak var subbView: UIView!
    
    @IBOutlet weak var collView: UICollectionView!
    var minimumValue = 0
    var maxValue = 0
    weak var delegate : getPriceSliderValues?
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
        self.removeFromSuperview()
        self.delegate?.slidermaxMinValue(min: self.minimumValue, max: self.maxValue)
    }
    func setUp(){
        self.collView.register(LineMeasureCell.nib(), forCellWithReuseIdentifier: LineMeasureCell.ident)
        self.seekView.delegate = self
        seekView.colorBetweenHandles = #colorLiteral(red: 0, green: 0.8693377376, blue: 0.7882207632, alpha: 1)
        seekView.tintColor = .white
        seekView.minLabelColor = .white
        seekView.maxLabelColor = .white
        self.collView.delegate = self
        self.collView.dataSource = self
       
    }
    
    @IBAction func removeBtnTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
extension PriceView : RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let upMin = minValue.rounded(.up)
        let upMax = maxValue.rounded(.up)
        self.minimumValue = Int(upMin)
        self.maxValue = Int(upMax)
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

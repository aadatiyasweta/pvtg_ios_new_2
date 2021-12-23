//
//  PriceView.swift
//  PVTG
//
//  Created by Techugo on 13/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//
protocol getPriceSliderValues : class{
    func slidermaxMinValue(min : Int , max : Int,currency : String,isSelectedFromFilter : Bool)
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
    var currencyArr = [String]()
    var pickerView = UIPickerView()
    var currentIndex = 0
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
        self.delegate?.slidermaxMinValue(min: self.minimumValue, max: self.maxValue, currency: "COP", isSelectedFromFilter: true)
    }
    func setUp(){
        self.collView.register(LineMeasureCell.nib(), forCellWithReuseIdentifier: LineMeasureCell.ident)
        self.seekView.delegate = self
      //  self.selectCurrencyFiled.inputView = self.pickerView
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
       // self.getCurrencyArr()
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
    
    @IBAction func fieldEndEditing(_ sender: UITextField) {
    
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
extension PriceView : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencyArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currencyArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentIndex = row
       
    }
}
extension PriceView{
    func getCurrencyArr(){
        api_manager.GETApi(getCurrencyDataUrl(id : SaveToDefaults().getUserId() ?? ""), param: nil, header: header()) { (json, err, code) in
            if let response = json{
                let data = try? response["currency"].rawData()
                let jsonDecoder = JSONDecoder()
                let arr = try? jsonDecoder.decode([String].self, from: data ?? Data())
                self.currencyArr = arr ?? self.currencyArr
                self.pickerView.reloadAllComponents()
//                for val in 0..<(self.currencyArr.count){
//                    if self.currencyArr[val] == self.selectCurrencyFiled.text{
//                        self.currentIndex = val
//                        self.pickerView.selectRow(self.currentIndex, inComponent: 0, animated: true)
//                        self.pickerView.reloadAllComponents()
//                        break
//                    }
//                }
            }
        }
    }
}

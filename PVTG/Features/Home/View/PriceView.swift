//
//  PriceView.swift
//  PVTG
//
//  Created by Techugo on 13/08/21.
//  Copyright © 2021 ShubhamMacmini. All rights reserved.
//
protocol getPriceSliderValues : AnyObject{
    func slidermaxMinValue(min : Int , max : Int,currency : String,isSelectedFromFilter : Bool)
    func resetFilter()
}
import Foundation
import UIKit
import RangeSeekSlider

class PriceView : UIView{
    
    //MARK: - Outlets
    @IBOutlet weak var seekView: RangeSeekSlider!
    @IBOutlet weak var subbView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var selectCurrencyFiled: UITextField!
    
    //MARK: - Properties
    var minimumValue = 0
    var maxValue = 0
    weak var delegate : getPriceSliderValues?
    var currencyArr = [String]()
    var selectedCurrency = ""
    var currenccyType = ""
    var pickerView = UIPickerView()
    var currentIndex = 0
    
    //MARK: - LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        selectCurrencyFiled.layer.borderWidth = 0.5
        selectCurrencyFiled.layer.borderColor = UIColor.lightGray.cgColor
        selectCurrencyFiled.layer.cornerRadius = 5
        selectCurrencyFiled.layer.masksToBounds = true
    }
    
    class func initWith(frame: CGRect)->PriceView? {
        let view = Bundle.main.loadNibNamed("PriceView", owner: self, options: nil)?[0] as? PriceView
        view?.frame = frame
        view?.setUp()
        return view
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func rightBtnTao(_ sender: UIButton) {
        self.removeFromSuperview()
        print(self.minimumValue)
        print(self.maxValue)
        self.delegate?.slidermaxMinValue(min: self.minimumValue, max: self.maxValue, currency: self.selectCurrencyFiled.text ?? "", isSelectedFromFilter: true)
    }
    
    //MARK: - METHOD TO SET UP
    func setUp(){
        if(self.selectedCurrency == ""){
            self.selectCurrencyFiled.text = "COP"
            self.selectedCurrency = "COP"
        }else {
            self.selectCurrencyFiled.text = selectedCurrency
        }
        self.collView.register(LineMeasureCell.nib(), forCellWithReuseIdentifier: LineMeasureCell.ident)
        self.seekView.delegate = self
        paddingTextfield(textfield: selectCurrencyFiled)
        self.selectCurrencyFiled.inputView = self.pickerView
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.getCurrencyArr()
        seekView.colorBetweenHandles = #colorLiteral(red: 0, green: 0.8693377376, blue: 0.7882207632, alpha: 1)
        seekView.minValue = CGFloat(CGFloat(self.minimumValue))
        seekView.maxValue = CGFloat(CGFloat(self.maxValue))
        print(self.maxValue)
        seekView.tintColor = .white
        seekView.minLabelColor = .white
        seekView.maxLabelColor = .white
        self.collView.delegate = self
        self.collView.dataSource = self
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func removeBtnTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        self.removeFromSuperview()
        self.maxValue = 600000
        self.delegate?.resetFilter()
    }
    
    @IBAction func fieldEndEditing(_ sender: UITextField) {
    }
}

//MARK: - RANGE SEEK SLIDER DELEGATE
extension PriceView : RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if((maxValue - minValue) > 6000){
            let upMin = minValue.rounded(.up)
            let upMax = maxValue.rounded(.up)
            self.minimumValue = Int(upMin)
            self.maxValue = Int(upMax)
        }
    }
}

//MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE
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

//MARK: - PICKER VIEW DELEGATE AND DATASOURCE
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
        self.selectCurrencyFiled.text = self.currencyArr[row]
        if(selectCurrencyFiled.text == "USD"){
            self.selectedCurrency = self.selectCurrencyFiled.text ?? ""
//            self.minimumValue = 0
//            self.maxValue = 300
//            self.seekView.minValue = 0
//            self.seekView.maxValue = 300
//            self.seekView.selectedMaxValue = CGFloat(300)
//            self.seekView.selectedMinValue = CGFloat(0)
//            self.seekView.delegate = self
        }else {
//            self.minimumValue = 0
//            self.maxValue = 600000
            self.selectedCurrency = self.selectCurrencyFiled.text ?? ""
//            self.seekView.minValue = 0
//            self.seekView.maxValue = 600000
//            self.seekView.selectedMaxValue = CGFloat(600000)
//            self.seekView.selectedMinValue = CGFloat(0)
//            self.seekView.delegate = self
        }
    }
}

//MARK: - UIVIEW EXTENSION
extension PriceView{
    func getCurrencyArr(){
        api_manager.GETApi(getCurrencyDataUrl(id : SaveToDefaults().getUserId() ?? ""), param: nil, header: header()) { (json, err, code) in
            if let response = json{
                let data = try? response["currency"].rawData()
                let jsonDecoder = JSONDecoder()
                let arr = try? jsonDecoder.decode([String].self, from: data ?? Data())
                self.currencyArr = arr ?? self.currencyArr
                self.pickerView.reloadAllComponents()
                for val in 0..<(self.currencyArr.count){
                    if self.currencyArr[val] == self.selectCurrencyFiled.text{
                        self.currentIndex = val
                        self.pickerView.selectRow(self.currentIndex, inComponent: 0, animated: true)
                        self.pickerView.reloadAllComponents()
                        break
                    }
                }
            }
        }
    }
    
}

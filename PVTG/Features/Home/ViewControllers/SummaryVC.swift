//
//  SummaryVC.swift
//  PVTG
//
//  Created by Test Machine on 29/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import Stripe

class SummaryVC: BaseViewController, GMSMapViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var discountViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imgLocn: UIImageView!
    @IBOutlet weak var vwAdddashedBordr: UIView!
    @IBOutlet weak var imgSession: UIImageView!
    @IBOutlet weak var lblCategry: UILabel!
    @IBOutlet weak var lblSessionNmae: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var Discount: UILabel! // here showing discount lbl
    @IBOutlet weak var btnAvlblPoints: UIButton!
    @IBOutlet weak var totalFare: UILabel!
    @IBOutlet weak var toatalTickets: UILabel!
    @IBOutlet weak var lblPlacewithDistance: UILabel!
    @IBOutlet weak var btnUseNow: UIButton!
    @IBOutlet weak var lblPoints: UILabel! // here showing points lbl
    @IBOutlet weak var vwmap: UIView!
    @IBOutlet weak var usePvtBtn: UIButton!
    @IBOutlet weak var rewardedString: UILabel!
    
    @IBOutlet weak var discountpriceTxtfld: UITextField!
    @IBOutlet weak var pointsBgVw: UIView!
    
    @IBOutlet weak var rewardPicImgBgVw: UIView!
    @IBOutlet weak var rewardCupBgVw: UIView!
    
    @IBOutlet weak var sessionTypLbl: UILabel!
    
    @IBOutlet weak var sesionTimeLbl: UILabel! // 8AM-8PM
    @IBOutlet weak var sesionDateLbl: UILabel! // 20 Feb 2025
    
    @IBOutlet weak var lblRate: UILabel!
    //MARK: - Properties
    var onboardingVm = OnboardingVm()
    var bookingDetails: SessionDetailResult?
    var ticketModel : GetTicketResult?
    var totalTkt = ""
    var vm = SessionDetailViewModel()
    var mapView:GMSMapView?
    var customModel : CustomBokingModel?
    var ammountPayment = ""
    var pointsPayent = ""
    var firstPointDiscount = 0
    var secondPointDiscount = 0
    var firstPoints = 0
    var secondPoins = 0
    // The user's points from the server, or 0 if they're missing or not a number
    private var availablePoints: Int {
        Int(Double(self.ticketModel?.total_point ?? "") ?? 0)
    }
    var isPointsUsed = false
    var selectedPoint = 0
    var getPriceFromPreviousPage = 0
    
    var discountValuePicker: UIPickerView!

    var discountValueArr = ["25%", "50%"]
    var selectedDiscounttStr = ""
    var selectedPointStr = ""
    var selectedPointIdStr = ""
    var getSessionTimeMinuteStr = ""
    var selectedSessionSTr = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //pointsBgVw.layer.borderWidth = 1
        //pointsBgVw.layer.borderColor = UIColor.white.cgColor
        
        rewardPicImgBgVw.layer.cornerRadius = 18
        rewardPicImgBgVw.clipsToBounds = true
//        rewardCupBgVw.layer.cornerRadius = 5
        rewardPicImgBgVw.clipsToBounds = true
        
        discountValuePicker = UIPickerView()

        discountValuePicker.dataSource = self
        discountValuePicker.delegate = self

        discountpriceTxtfld.inputView = discountValuePicker
        
        self.discountViewHeightCons.constant = 30
        self.onboardingVm.delegate = self
        self.vm.bookingDelegate = self
        DispatchQueue.main.async {
            self.SetMap()
        }
        self.onboardingVm.hitOnboaridngApi()
        btnAvlblPoints.isUserInteractionEnabled = false
        self.setDta()
        // Do any additional setup after loading the view.
        sessionTypLbl.text = self.selectedSessionSTr
        let timeZoneIdentifier = TimeZone.current.identifier
        print(timeZoneIdentifier)
        if let time1 = self.customModel?.booking_from_time, let toTime = self.customModel?.booking_to_time {
            let time1Str = changeDateFormatForReminder(date: time1, fromFormat: "HH:mm", toFormat: "hha", currentTimeZone: timeZoneIdentifier)
            let time2Str = changeDateFormatForReminder(date: toTime, fromFormat: "HH:mm", toFormat: "hha", currentTimeZone: timeZoneIdentifier)
            self.sesionTimeLbl.text = "\(time1Str.lowercased()) - \(time2Str.lowercased())"
        }
        //sesionTimeLbl.text = (self.customModel?.booking_from_time ?? "") + (self.customModel?.booking_to_time ?? "")
        
        let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = inputFormatter.date(from: self.customModel?.booking_date ?? "") {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "d MMM yyyy"
                let strr = outputFormatter.string(from: date)
                sesionDateLbl.text = strr
            }
        
        //sesionDateLbl.text = self.customModel?.booking_date ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usePvtBtn.isSelected = false
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        self.lblPoints.layer.cornerRadius = 22
        let myImage = #imageLiteral(resourceName: "loc")
        let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
        imgLocn.image = tintableImage
        imgLocn.tintColor = .white
        
//        DispatchQueue.main.async {
//            self.vwAdddashedBordr.addDashedBorder()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.vwAdddashedBordr.addDashedBorder()
//        })
    }
    
    //MARK: - METHOD TO SET MAP
    func SetMap(){
        if let lat1 = self.bookingDetails?.latitude , let long1 = self.bookingDetails?.longitude{
            let lat = Double(lat1)
            let long = Double(long1)
            let location = CLLocationCoordinate2D(latitude: lat ?? 0.0 , longitude: long ?? 0.0 )
            let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0.0 , longitude: long ?? 0.0 , zoom: 15, bearing: 0,
                                                  viewingAngle: 40)
            mapView = GMSMapView.map(withFrame: self.vwmap.bounds, camera: camera)
            self.vwmap.addSubview(mapView ?? GMSMapView())
            mapView?.delegate = self
            mapView?.isUserInteractionEnabled = true
            let marker = GMSMarker()
            let markerImage = UIImage(named: "polylineMarker")
            let markerView = UIImageView(image: markerImage)
            markerView.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
            markerView.contentMode = .scaleAspectFit
            marker.iconView = markerView
            marker.position = location
            marker.map = mapView
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func useNow(_ sender: Any) {
        if self.availablePoints < self.selectedPoint{
            showAlertView("Your available points is low", title: appName)
        }else{
            if(selectedPointStr == ""){
                selectedPointStr = self.lblPoints.text?.replacingOccurrences(of: " Pts", with: "") ?? ""
                self.selectedPoint = Int(selectedPointStr) ?? 0
                selectedPointStr = ""
            }
        isPointsUsed = true
        let strDiscountWithoutPercent  = self.Discount.text?.replacingOccurrences(of: "% Discount", with: "") ?? ""
        let intDiscountWithOUtPercent = Int(strDiscountWithoutPercent) ?? 0
        let discountGiven = Double(intDiscountWithOUtPercent) / Double(100)
        if let price = self.customModel?.paid_amount {
            if let tkt = Int(self.totalTkt){
                print("ticket\(self.totalTkt)")
                print("booking currency\(String(describing: self.bookingDetails?.currency))")
                var priceString = ""
                var myDouble  = Double(price) ?? 0.0
                myDouble = myDouble * Double(tkt)
                let totalPrice = myDouble
                let totalDiscount   = myDouble * discountGiven
                let priceAfterDiscount = totalPrice - totalDiscount
                let strPrice = self.customModel?.paid_amount ?? ""
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale =  Locale(identifier: "en_US")
                let intPrice = Int(strPrice)
                if(intPrice != nil){
                    currencyFormatter.minimumFractionDigits = 0
                }else {
                    currencyFormatter.minimumFractionDigits = 2
                }
                priceString = currencyFormatter.string(from: NSNumber(value: priceAfterDiscount ))!
                let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                self.totalFare.text = replaced + " " +  (self.bookingDetails?.currency ?? "")
                //let val = Int(self.ticketModel?.total_point ?? "0")! - self.secondPoins // added by ashitesh
                let val = self.availablePoints - self.selectedPoint // added by ashitesh
                self.btnAvlblPoints.setTitle("\(val)", for: .normal)
                /*self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)*/ // added by ashitesh
                
//                self.vwAdddashedBordr.alpha = 0.5
//                self.btnUseNow.alpha = 0.5
//                self.btnUseNow.isUserInteractionEnabled = false
//                self.discountpriceTxtfld.isUserInteractionEnabled = false
//                self.vwAdddashedBordr.isHidden = true
//                self.btnUseNow.isHidden = true
//                self.btnUseNow.isUserInteractionEnabled = false
//                self.discountpriceTxtfld.isUserInteractionEnabled = false
                self.discountViewHeightCons.constant = 30
            }
        }
        }
    }
    
    @IBAction func tapPaynow(_ sender: UIButton) {
        var amount = ""
        var points = ""
        var price = 0
        var flaotPrice : CGFloat = 0.0
        if let n = NumberFormatter().number(from: self.customModel?.paid_amount ?? "") {
            flaotPrice = CGFloat(truncating: n)
            
        }
        if let tkt = Int(self.totalTkt){
            price = tkt*Int(flaotPrice)
            amount = "\(price)"
        }
        if self.isPointsUsed == true{
//            if Int(self.ticketModel?.total_point ?? "0")! < self.secondPoins{
//                let perctange = (price*self.firstPointDiscount)/100
//                amount = "\(price-perctange)"
//                points = "\(self.firstPoints)"
//            }
//            else{
//                if self.secondPointDiscount == 0{
//                    amount = "0"
//                    points = "\(self.secondPoins)"
//                }else{
//                    let perctange = (price*self.secondPointDiscount)/100
//                    amount = "\(price-perctange)"
//                    points = "\(self.secondPoins)"
//                }
//            }
            // above commented by ashitesh
            let strDiscountWithoutPercent  = self.Discount.text?.replacingOccurrences(of: "% Discount", with: "") ?? ""
            let intDiscountWithOUtPercent = Int(strDiscountWithoutPercent) ?? 0
            let perctange = (price*intDiscountWithOUtPercent)/100
                    amount = "\(price-perctange)"
                    points = "\(self.selectedPoint)"
        }

        self.ammountPayment = amount
        self.pointsPayent = points
        self.doPayment()
    }
    
    @IBAction func viewCancelPolicyBtntap(_ sender: UIButton) {
        let vc = PrivacyPolicyVC.instance()
        vc.type = R.string.localizable.cancelPolicy()
        vc.url = cancelPolicy
        vc.isComingCancelBooking = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapUseNow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
//            self.vwAdddashedBordr.alpha = 1
//            self.btnUseNow.alpha = 1
//            self.btnUseNow.isUserInteractionEnabled = true
//            self.discountpriceTxtfld.isUserInteractionEnabled = true
            self.vwAdddashedBordr.isHidden = false
            self.btnUseNow.isHidden = false
//            self.btnUseNow.isUserInteractionEnabled = true
//            self.discountpriceTxtfld.isUserInteractionEnabled = true
            self.discountViewHeightCons.constant = 30
            if self.availablePoints < self.secondPoins{
                self.Discount.text = "\(firstPointDiscount)% \(R.string.localizable.discount())"
                self.lblPoints.text = "\(self.firstPoints) \(R.string.localizable.pts())"
                self.selectedPoint = self.firstPoints
//                let val = Int(self.ticketModel?.total_point ?? "0")! - self.firstPoints
                let val = self.availablePoints // commented by ashitesh
                self.btnAvlblPoints.setTitle("\(val)", for: .normal)
            }else{
                if self.secondPointDiscount == 0{
                    self.Discount.text = R.string.localizable.free()
                }else{
                    self.Discount.text = "\(self.secondPointDiscount)% Discount"
                }
                self.lblPoints.text = "\(self.secondPoins) \(R.string.localizable.pts())"
                self.selectedPoint = self.secondPoins
//                let val = Int(self.ticketModel?.total_point ?? "0")! - self.secondPoins // commented by ashitesh
                let val = self.availablePoints
                self.btnAvlblPoints.setTitle("\(val)", for: .normal)
            }
//            if Int(self.ticketModel?.total_point ?? "0")! < self.selectedPoint{
//                showAlertView("Your available points is low", title: appName)
//            }else{
//                let val = Int(self.ticketModel?.total_point ?? "0")!
//                self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
//            }
            
        }else{
//            self.vwAdddashedBordr.alpha = 0.5
//           self.btnUseNow.alpha = 0.5
//            self.btnUseNow.isUserInteractionEnabled = false
//            self.discountpriceTxtfld.isUserInteractionEnabled = false
            self.vwAdddashedBordr.isHidden = true
            self.btnUseNow.isHidden = true
//            self.btnUseNow.isUserInteractionEnabled = false
//            self.discountpriceTxtfld.isUserInteractionEnabled = false
            self.discountViewHeightCons.constant = 30
            let val = (self.ticketModel?.total_point)!
            self.btnAvlblPoints.setTitle("\(val)", for: .normal)
            self.setOriginalPriceWithOutDiscount()
        }
    }
    
    private func setOriginalPriceWithOutDiscount(){
        if let price = self.customModel?.paid_amount {
            print("Price is",price);
            if let tkt = Int(self.totalTkt){
                print("ticket\(self.totalTkt)")
                print("booking currency\(String(describing: self.bookingDetails?.currency))")
                var priceString = ""
                var myDouble  = Double(price) ?? 0.0
                myDouble = myDouble * Double(tkt)
                let totalPrice = myDouble
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale =  Locale(identifier: "en_US")
                
                let strPrice = self.customModel?.paid_amount ?? ""
                let intPrice = Int(strPrice)
                if(intPrice !=  nil){
                    currencyFormatter.minimumFractionDigits = 0
                }else {
                    currencyFormatter.minimumFractionDigits = 2
                }
                priceString = currencyFormatter.string(from: NSNumber(value: totalPrice ))!
                let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                self.totalFare.text = replaced + " " +  (self.bookingDetails?.currency ?? "")
//                self.vwAdddashedBordr.alpha = 0.5
//                self.btnUseNow.alpha = 0.5
//                self.btnUseNow.isUserInteractionEnabled = false
//                self.discountpriceTxtfld.isUserInteractionEnabled = false
                self.vwAdddashedBordr.isHidden = true
                self.btnUseNow.isHidden = true
//                self.btnUseNow.isUserInteractionEnabled = false
//                self.discountpriceTxtfld.isUserInteractionEnabled = false
                self.discountViewHeightCons.constant = 30
            }
        }
    }
    
    //MARK: - METHOD TO SHOW USED POINT
    private func showUseNow(){
//        self.vwAdddashedBordr.alpha = 0.5
//        self.btnUseNow.alpha = 0.5
//        self.btnUseNow.isUserInteractionEnabled = true
//        self.discountpriceTxtfld.isUserInteractionEnabled = true
        self.vwAdddashedBordr.isHidden = true
        self.btnUseNow.isHidden = true
        self.discountViewHeightCons.constant = 30
        if self.availablePoints < self.secondPoins{
            self.Discount.text = "\(firstPointDiscount)% \(R.string.localizable.discount())"
            self.lblPoints.text = "\(self.firstPoints) \(R.string.localizable.pts())"
            self.selectedPoint = self.firstPoints
//            let val = Int(self.ticketModel?.total_point ?? "0")! - self.firstPoints // commented by ashitesh
            
            let val = self.availablePoints
//            self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
            self.btnAvlblPoints.setTitle("\(val)", for: .normal)
        }else{
            if self.secondPointDiscount == 0{
                self.Discount.text = R.string.localizable.free()
                
            }else{
                self.Discount.text = "\(self.secondPointDiscount)% Discount"
            }
            self.lblPoints.text = "\(self.secondPoins) \(R.string.localizable.pts())"
            self.selectedPoint = self.firstPoints
//            let val = Int(self.ticketModel?.total_point ?? "0")! - self.secondPoins // commented by ashitesh
            let val = self.availablePoints
//            self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
            self.btnAvlblPoints.setTitle("\(val)", for: .normal)
        }
    }
}

//MARK: - VIEW CONTROLLER EXTENSION
extension SummaryVC {
    func setDta() {
        if let name = self.bookingDetails?.name_of_listing, let rating = self.bookingDetails?.rating, let place = self.bookingDetails?.city, let dist = self.bookingDetails?.distance, let price = self.customModel?.paid_amount{
            let pt = Int(self.ticketModel?.total_point ?? "0")
            var url = ""
            for val in self.bookingDetails?.images ?? []{
                if val.is_cover ?? "" == "1"{
                    url = val.session_image ?? ""
                    break
                }
            }
            self.lblCategry.text = self.bookingDetails?.category_name ?? ""
//            loadImage(url, self.imgSession, activity: nil, defaultImage: nil)
            var stringCapitalized = name.uppercased
            self.lblSessionNmae.text = stringCapitalized()
            self.vwRating.rating = Double(rating)!
            self.lblRate.text = rating
            let value = Double(dist) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " " + R.string.localizable.kmaway(doubleStr)
            self.lblPlacewithDistance.text = str
            self.toatalTickets.text = self.totalTkt
            var flaotPrice : CGFloat = 0.0
            if let n = NumberFormatter().number(from: price) {
                flaotPrice = CGFloat(truncating: n)
                
            }
            
            if let tkt = Int(self.totalTkt){
                var priceString = ""
                var myDouble  = Double(price) ?? 0.0
                myDouble = myDouble * Double(tkt)
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                
                let intPrice = Int(price)
                if(intPrice !=  nil){
                    currencyFormatter.minimumFractionDigits = 0
                }else {
                    currencyFormatter.minimumFractionDigits = 2
                    
                }
                currencyFormatter.locale =  Locale(identifier: "en_US")
                priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
                let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                self.totalFare.text = replaced + " " +  (self.bookingDetails?.currency ?? "")
            }
            self.btnAvlblPoints.setTitle("\(pt ?? 0)", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                self.vwAdddashedBordr.addDashedBorder()
            })
        }
    }
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=driving&key=AIzaSyC6hyx1WnYOhTnbbvdYR-f7nWvVqyHgn2k")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count > 0{
                            let routes = preRoutes[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                            
                            DispatchQueue.main.async(execute: {
                                let path = GMSPath(fromEncodedPath: polyString)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 5.0
                                polyline.strokeColor = UIColor.orange
                                polyline.map = self.mapView
                            })
                        }
                    }
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    func doPayment(){
        let viewController = CardEntryVC()
        viewController.onCancel = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
        viewController.onToken = { [weak self] token in
            self?.cardTokenCreated(token)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: - MAKE PAYMENT FROM STRIPE
    func makePayment(stripetoken:STPToken){
        let email = SaveToDefaults().getEmail() ?? ""
        let acessToken = SaveToDefaults().getAccessToken() ?? ""
        if let id = SaveToDefaults().getUserId(){
            var currency = self.bookingDetails?.currency ?? "COP"
            if(currency == "$"){
                currency = "USD"
            }
            let strDiscountWithoutPercent  = self.Discount.text?.replacingOccurrences(of: "% Discount", with: "") ?? ""
            let intDiscountWithOUtPercent = Int(strDiscountWithoutPercent) ?? 0
            let discountGiven = Double(intDiscountWithOUtPercent) / Double(100)
            
            let amount = self.customModel?.paid_amount ?? ""
            print(amount)
            if let price = self.customModel?.paid_amount {
                if let tkt = Int(self.totalTkt){
                    var myDouble  = Double(price) ?? 0.0
                    myDouble = myDouble * Double(tkt)
                    let totalPrice = myDouble
                    let totalDiscount   = myDouble * discountGiven
                    let priceAfterDiscount = totalPrice - totalDiscount
                    var strAmount = ""
                    if(self.isPointsUsed ==  true){
                        strAmount = String(Int(priceAfterDiscount.rounded(.toNearestOrEven)))
                    }else {
                        strAmount = String(Int(totalPrice.rounded(.toNearestOrEven)))
                    }
//                    if(Int(strAmount) ?? 0 < 2020){
//                        showAlertView("Amount should be atleast 2020", title: appName)
//                    }else{
                        self.vm.makePAymentStripe(user_id: id, stripeytoken: stripetoken.tokenId, ammount: strAmount, currency: currency, email: email, token: acessToken,sessionId: self.customModel?.session_id ?? ""){ data in
                            if(data != ""){
                                self.bookSession(transactionID: data)
                            }
                        }
                   // }
                }
            }
        }
    }
    
    //MARK: - METHOD TO HIT SESSION BOOKING API
    private func bookSession(transactionID:String) {
        self.vm.sessionBookingApi(user_id: self.customModel?.user_id ?? "", session_id: self.customModel?.session_id ?? "", ticket: self.totalTkt, booking_date: self.customModel?.booking_date ?? "", booking_from_time: self.customModel?.booking_from_time ?? "", booking_to_time: self.customModel?.booking_to_time ?? "", paid_amount: self.ammountPayment, schedule_time_id: self.customModel?.schedule_time_id ?? "",points:self.pointsPayent,session_type_id: self.customModel?.offeredTypeId ?? "",paymentId: transactionID, session_time_minute: self.getSessionTimeMinuteStr, selectedSessionSTr : self.selectedSessionSTr)
    }
}

//MARK: - CUSTOM DELEGATE
extension SummaryVC : GetBookingResponse,getOnboardingResponse{
    func getOnboardingData() {
        self.discountValueArr.removeAll()
        if self.onboardingVm.model?.rewards?.count == 2{
            self.firstPoints = Int(self.onboardingVm.model?.rewards?[0].points ?? "0") ?? 0
            self.secondPoins = Int(self.onboardingVm.model?.rewards?[1].points ?? "0") ?? 0
            let str = self.onboardingVm.model?.rewards?[0].discount ?? "0"
            if str.contains("%"){
                let first = str.split(separator: "%")[0].description
                self.firstPointDiscount = Int(first) ?? 0
            }
            for i in 0..<(self.onboardingVm.model?.rewards?.count ?? 0){
                self.Discount.text = (self.onboardingVm.model?.rewards?[0].discount ?? "") + " Discount"
                self.discountValueArr.append(self.onboardingVm.model?.rewards?[i].discount ?? "")
            }
            self.discountValuePicker.reloadAllComponents()
            let str1 = self.onboardingVm.model?.rewards?[1].discount ?? "0"
            if str1.contains("%"){
                let first = str1.split(separator: "%")[0].description
                self.secondPointDiscount = Int(first) ?? 0
            }
        }
        let pt = Int(self.ticketModel?.total_point ?? "0")
//        if pt ?? 0 < firstPoints{
//           self.usePvtBtn.isUserInteractionEnabled = false
//        }else{
//            self.usePvtBtn.isUserInteractionEnabled = true
//            self.showUseNow()
//            self.usePvtBtn.isSelected = false
//        }
        if self.ticketModel?.user_booking ?? 0 == 0{
            self.rewardedString.text = R.string.localizable.youWillBeRewarded(self.onboardingVm.model?.point_accumulation?.first_booking_point ?? "")
        }else{
            self.rewardedString.text = R.string.localizable.youWillBeRewarded(self.onboardingVm.model?.point_accumulation?.bookings ?? "")
        }
    }
    
    func bookingSuccess() {
        let vc = ThankyouVC.instance()
        if self.ticketModel?.user_booking ?? 0 == 0{
            vc.points = self.onboardingVm.model?.point_accumulation?.first_booking_point ?? ""
        }else{
            vc.points = self.onboardingVm.model?.point_accumulation?.bookings ?? ""
        }
        vc.name = self.bookingDetails?.name_of_listing ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - CARD TOKEN CREATED
extension SummaryVC {
    func cardTokenCreated(_ token: STPToken) {
        print("Stripe card token created")
        dismiss(animated: false, completion: nil)
        self.makePayment(stripetoken: token)
    }
}

//MARK: - CARD ENTRY SCREEN
// Stripe 26 removed its ready-made card screen (STPAddCardViewController), so this rebuilds the same look:
// card picture on top (flips for the CVC), a "Card" title and the card field in a rounded box, in Stripe's old colours.
// It turns the card into the same one-time token as before, so the server payment flow doesn't change.
final class CardEntryVC: UIViewController, STPPaymentCardTextFieldDelegate {
    var onCancel: (() -> Void)?
    var onToken: ((STPToken) -> Void)?

    // Colours from Stripe's old default theme
    private let pageColor = UIColor(red: 242/255, green: 242/255, blue: 245/255, alpha: 1)
    private let textColor = UIColor(red: 43/255, green: 43/255, blue: 45/255, alpha: 1)
    private let labelColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    private let accentColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    private let errorColor = UIColor(red: 1, green: 72/255, blue: 68/255, alpha: 1)
    private let lineColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1)

    private let scrollView = UIScrollView()
    private let cardImageView = UIImageView(image: UIImage(named: "CardFormFront"))
    private let sectionLabel = UILabel()
    private let cardRow = UIView()
    private let cardField = STPPaymentCardTextField()
    private let errorLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        title = "Add a Card"
        view.backgroundColor = pageColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false

        cardImageView.contentMode = .center
        cardImageView.tintColor = accentColor

        sectionLabel.text = "Card"
        sectionLabel.font = .systemFont(ofSize: 15)
        sectionLabel.textColor = labelColor

        // Rounded box around the card field; the border turns blue while typing
        cardRow.backgroundColor = .white
        cardRow.layer.cornerRadius = 12
        cardRow.layer.borderWidth = 1
        cardRow.layer.borderColor = lineColor.cgColor
        cardField.postalCodeEntryEnabled = false
        cardField.delegate = self
        cardField.borderWidth = 0
        cardField.cornerRadius = 0
        cardField.backgroundColor = .clear
        cardField.font = .systemFont(ofSize: 17)
        cardField.textColor = textColor
        cardField.placeholderColor = labelColor
        cardField.textErrorColor = errorColor
        cardField.cursorColor = accentColor

        errorLabel.textColor = errorColor
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0

        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        let content = UIView()
        [scrollView, content, cardImageView, sectionLabel, cardRow, cardField, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(scrollView)
        scrollView.addSubview(content)
        [cardImageView, sectionLabel, cardRow, errorLabel].forEach { content.addSubview($0) }
        cardRow.addSubview(cardField)

        let imageHeight = (cardImageView.image?.size.height ?? 111) + 57 * 2
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            cardImageView.topAnchor.constraint(equalTo: content.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            cardImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            sectionLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: content.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            sectionLabel.trailingAnchor.constraint(equalTo: content.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            cardRow.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 8),
            cardRow.leadingAnchor.constraint(equalTo: content.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            cardRow.trailingAnchor.constraint(equalTo: content.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            cardRow.heightAnchor.constraint(equalToConstant: 56),

            cardField.topAnchor.constraint(equalTo: cardRow.topAnchor),
            cardField.bottomAnchor.constraint(equalTo: cardRow.bottomAnchor),
            cardField.leadingAnchor.constraint(equalTo: cardRow.leadingAnchor, constant: 12),
            cardField.trailingAnchor.constraint(equalTo: cardRow.trailingAnchor, constant: -12),

            errorLabel.topAnchor.constraint(equalTo: cardRow.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: sectionLabel.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: sectionLabel.trailingAnchor),
            errorLabel.bottomAnchor.constraint(lessThanOrEqualTo: content.bottomAnchor, constant: -20)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.tintColor = accentColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardField.becomeFirstResponder()
    }

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        doneButton.isEnabled = textField.isValid
        errorLabel.text = nil
    }

    func paymentCardTextFieldDidBeginEditing(_ textField: STPPaymentCardTextField) {
        cardRow.layer.borderColor = accentColor.cgColor
    }

    func paymentCardTextFieldDidEndEditing(_ textField: STPPaymentCardTextField) {
        cardRow.layer.borderColor = lineColor.cgColor
    }

    // Flip the card picture to its back while the CVC is typed, like the old screen
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        let number = textField.paymentMethodParams.card?.number ?? ""
        let back = STPCardValidator.brand(forNumber: number) == .amex ? "CardFormAmexCVC" : "CardFormBack"
        setCardImage(named: back, flip: .transitionFlipFromRight)
    }

    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        setCardImage(named: "CardFormFront", flip: .transitionFlipFromLeft)
    }

    private func setCardImage(named name: String, flip: UIView.AnimationOptions) {
        UIView.transition(with: cardImageView, duration: 0.2, options: flip, animations: {
            self.cardImageView.image = UIImage(named: name)
        })
    }

    @objc private func cancelTapped() {
        onCancel?()
    }

    @objc private func doneTapped() {
        guard cardField.isValid, let card = cardField.paymentMethodParams.card else { return }
        let params = STPCardParams()
        params.number = card.number
        params.expMonth = card.expMonth?.uintValue ?? 0
        params.expYear = card.expYear?.uintValue ?? 0
        params.cvc = card.cvc

        setLoading(true)
        STPAPIClient.shared.createToken(withCard: params) { [weak self] token, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.setLoading(false)
                if let token = token {
                    self.onToken?(token)
                } else {
                    self.errorLabel.text = error?.localizedDescription ?? somethingWentWrongMessage
                }
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        cardField.isUserInteractionEnabled = !loading
        navigationItem.leftBarButtonItem?.isEnabled = !loading
        if loading {
            spinner.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        } else {
            navigationItem.rightBarButtonItem = doneButton
            doneButton.isEnabled = cardField.isValid
        }
    }
}

extension SummaryVC : UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return discountValueArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return discountValueArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        Discount.text = discountValueArr[row] + " Discount"
        lblPoints.text = (self.onboardingVm.model?.rewards?[row].points ?? "0")
        + " \(R.string.localizable.pts())"
        selectedPointStr = self.onboardingVm.model?.rewards?[row].points ?? "0"
        self.selectedPoint = Int(self.selectedPointStr) ?? 0
        selectedDiscounttStr = self.onboardingVm.model?.rewards?[row].discount ?? "0"
        selectedPointIdStr = self.onboardingVm.model?.rewards?[row].id ?? "0"
        self.view.endEditing(true)
        //pickerMaximumValue.isHidden = true
        //connectLimitPickerHeight.constant = 10
    }
}



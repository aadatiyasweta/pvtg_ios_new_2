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
    @IBOutlet weak var Discount: UILabel!
    @IBOutlet weak var btnAvlblPoints: UIButton!
    @IBOutlet weak var totalFare: UILabel!
    @IBOutlet weak var toatalTickets: UILabel!
    @IBOutlet weak var lblPlacewithDistance: UILabel!
    @IBOutlet weak var btnUseNow: UIButton!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var vwmap: UIView!
    @IBOutlet weak var usePvtBtn: UIButton!
    @IBOutlet weak var rewardedString: UILabel!
    
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
    var isPointsUsed = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.discountViewHeightCons.constant = 0
        self.onboardingVm.delegate = self
        self.vm.bookingDelegate = self
        DispatchQueue.main.async {
            self.SetMap()
        }
        self.onboardingVm.hitOnboaridngApi()
        btnAvlblPoints.isUserInteractionEnabled = false
        self.setDta()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        self.lblPoints.layer.cornerRadius = 22
        let myImage = #imageLiteral(resourceName: "loc")
        let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
        imgLocn.image = tintableImage
        imgLocn.tintColor = .white
        
        DispatchQueue.main.async {
            self.vwAdddashedBordr.addDashedBorder()
        }
    }
    
    //MARK: - METHOD TO SET MAP
    func SetMap(){
        if let lat1 = self.bookingDetails?.latitude , let long1 = self.bookingDetails?.longitude{
            let lat = Double(lat1)
            let long = Double(long1)
            let location = CLLocationCoordinate2D(latitude: lat! , longitude: long! )
            let camera = GMSCameraPosition.camera(withLatitude: lat! , longitude: long! , zoom: 15, bearing: 0,
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
        isPointsUsed = true
        let strDiscountWithoutPercent  = self.Discount.text?.replacingOccurrences(of: "%", with: "") ?? ""
        let intDiscountWithOUtPercent = Int(strDiscountWithoutPercent) ?? 0
        let discountGiven = Double(intDiscountWithOUtPercent) / Double(100)
        if let price = self.customModel?.paid_amount {
            print(price)
            if let tkt = Int(self.totalTkt){
                print("ticket\(self.totalTkt)")
                print("booking currency\(String(describing: self.bookingDetails?.currency))")
                var priceString = ""
                var myDouble  = Double(price) ?? 0.0
                myDouble = myDouble * Double(tkt)
                let totalPrice = myDouble
                print(myDouble)
                let totalDiscount   = myDouble * discountGiven
                let priceAfterDiscount = totalPrice - totalDiscount
                print(myDouble)
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
                self.totalFare.text = replaced + " " +  self.bookingDetails!.currency!
                print(replaced)
                self.vwAdddashedBordr.isHidden = true
                self.btnUseNow.isHidden = true
                self.discountViewHeightCons.constant = 0
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
            if Int(self.ticketModel?.total_point ?? "0")! < self.secondPoins{
                let perctange = (price*self.firstPointDiscount)/100
                amount = "\(price-perctange)"
                points = "\(self.firstPoints)"
            }
            else{
                if self.secondPointDiscount == 0{
                    amount = "0"
                    points = "\(self.secondPoins)"
                }else{
                    let perctange = (price*self.secondPointDiscount)/100
                    amount = "\(price-perctange)"
                    points = "\(self.secondPoins)"
                }
            }
        }
        
        if let n = NumberFormatter().number(from: amount) {
            flaotPrice = CGFloat(truncating: n)
        }
        
        self.ammountPayment = amount
        self.pointsPayent = points
        self.vm.getPrefrenceIdApi(price: flaotPrice, name: self.customModel?.sessionName ?? "", desc: self.customModel?.sessionDesc ?? "", currency: "$")
    }
    
    @IBAction func viewCancelPolicyBtntap(_ sender: UIButton) {
        let vc = PrivacyPolicyVC.instance()
        vc.type = R.string.localizable.cancelPolicy()
        vc.url = cancelPolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapUseNow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.vwAdddashedBordr.isHidden = false
            self.btnUseNow.isHidden = false
            self.discountViewHeightCons.constant = 50
            if Int(self.ticketModel?.total_point ?? "0")! < self.secondPoins{
                self.Discount.text = "\(firstPointDiscount)% \(R.string.localizable.discount())"
                self.lblPoints.text = "\(self.firstPoints) \(R.string.localizable.pts())"
                let val = Int(self.ticketModel?.total_point ?? "0")! - self.firstPoints
                self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
            }else{
                if self.secondPointDiscount == 0{
                    self.Discount.text = R.string.localizable.free()
                }else{
                    self.Discount.text = "\(self.secondPointDiscount)%"
                }
                self.lblPoints.text = "\(self.secondPoins) \(R.string.localizable.pts())"
                let val = Int(self.ticketModel?.total_point ?? "0")! - self.secondPoins
                self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
            }
        }else{
            self.vwAdddashedBordr.isHidden = true
            self.btnUseNow.isHidden = true
            self.discountViewHeightCons.constant = 0
            let val = (self.ticketModel?.total_point)!
            self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
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
                print(myDouble)
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
                self.totalFare.text = replaced + " " +  self.bookingDetails!.currency!
                print(replaced)
                self.vwAdddashedBordr.isHidden = true
                self.btnUseNow.isHidden = true
                self.discountViewHeightCons.constant = 0
            }
        }
    }
    
    //MARK: - METHOD TO SHOW USED POINT
    private func showUseNow(){
        self.vwAdddashedBordr.isHidden = false
        self.btnUseNow.isHidden = false
        self.discountViewHeightCons.constant = 50
        if Int(self.ticketModel?.total_point ?? "0")! < self.secondPoins{
            self.Discount.text = "\(firstPointDiscount)% \(R.string.localizable.discount())"
            self.lblPoints.text = "\(self.firstPoints) \(R.string.localizable.pts())"
            let val = Int(self.ticketModel?.total_point ?? "0")! - self.firstPoints
            self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
        }else{
            if self.secondPointDiscount == 0{
                self.Discount.text = R.string.localizable.free()
                
            }else{
                self.Discount.text = "\(self.secondPointDiscount)%"
            }
            self.lblPoints.text = "\(self.secondPoins) \(R.string.localizable.pts())"
            let val = Int(self.ticketModel?.total_point ?? "0")! - self.secondPoins
            self.btnAvlblPoints.setTitle("\(val) \(R.string.localizable.ptsavailable())", for: .normal)
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
            loadImage(url, self.imgSession, activity: nil, defaultImage: nil)
            self.lblSessionNmae.text = name
            self.vwRating.rating = Double(rating)!
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
                print("ticket\(self.totalTkt)")
                print("booking currency\(String(describing: self.bookingDetails?.currency))")
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
                self.totalFare.text = replaced + " " +  self.bookingDetails!.currency!
                print(replaced)
                print(flaotPrice)
            }
            self.btnAvlblPoints.setTitle("\(pt ?? 0) \(R.string.localizable.ptsavailable())", for: .normal)
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
    
    func doPayment(id : String){
        print(id)
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: - MAKE PAYMENT FROM STRIPE
    func makePayment(stripetoken:STPToken){
        let email = SaveToDefaults().getEmail() ?? ""
        print(stripetoken.tokenId)
        
        let acessToken = SaveToDefaults().getAccessToken() ?? ""
        if let id = SaveToDefaults().getUserId(){
            var currency = self.bookingDetails?.currency ?? "COP"
            if(currency == "$"){
                currency = "USD"
            }
            let strDiscountWithoutPercent  = self.Discount.text?.replacingOccurrences(of: "%", with: "") ?? ""
            let intDiscountWithOUtPercent = Int(strDiscountWithoutPercent) ?? 0
            let discountGiven = Double(intDiscountWithOUtPercent) / Double(100)
            
            let amount = self.customModel?.paid_amount ?? ""
            print(amount)
            if let price = self.customModel?.paid_amount {
                if let tkt = Int(self.totalTkt){
                    print("ticket\(self.totalTkt)")
                    print("booking currency\(String(describing: self.bookingDetails?.currency))")
                    var myDouble  = Double(price) ?? 0.0
                    myDouble = myDouble * Double(tkt)
                    let totalPrice = myDouble
                    print(myDouble)
                    let totalDiscount   = myDouble * discountGiven
                    let priceAfterDiscount = totalPrice - totalDiscount
                    var strAmount = ""
                    if(self.isPointsUsed ==  true){
                        strAmount = String(Int(priceAfterDiscount.rounded(.toNearestOrEven)))
                    }else {
                        strAmount = String(Int(totalPrice.rounded(.toNearestOrEven)))
                    }
                    
                    self.vm.makePAymentStripe(user_id: id, stripeytoken: stripetoken.tokenId, ammount: strAmount, currency: currency, email: email, token: acessToken,sessionId: self.customModel?.session_id ?? ""){ data in
                        if(data != ""){
                            self.bookSession(transactionID: data)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - METHOD TO HIT SESSION BOOKING API
    private func bookSession(transactionID:String) {
        self.vm.sessionBookingApi(user_id: self.customModel?.user_id ?? "", session_id: self.customModel?.session_id ?? "", ticket: self.totalTkt, booking_date: self.customModel?.booking_date ?? "", booking_from_time: self.customModel?.booking_from_time ?? "", booking_to_time: self.customModel?.booking_to_time ?? "", paid_amount: self.ammountPayment, schedule_time_id: self.customModel?.schedule_time_id ?? "",points:self.pointsPayent,session_type_id: self.customModel?.offeredTypeId ?? "",paymentId: transactionID)
    }
}

//MARK: - CUSTOM DELEGATE
extension SummaryVC : GetBookingResponse,getOnboardingResponse{
    func getOnboardingData() {
        if self.onboardingVm.model?.rewards?.count == 2{
            self.firstPoints = Int(self.onboardingVm.model?.rewards?[0].points ?? "0") ?? 0
            self.secondPoins = Int(self.onboardingVm.model?.rewards?[1].points ?? "0") ?? 0
            let str = self.onboardingVm.model?.rewards?[0].discount ?? "0"
            if str.contains("%"){
                let first = str.split(separator: "%")[0].description
                self.firstPointDiscount = Int(first) ?? 0
            }
            let str1 = self.onboardingVm.model?.rewards?[1].discount ?? "0"
            if str1.contains("%"){
                let first = str1.split(separator: "%")[0].description
                self.secondPointDiscount = Int(first) ?? 0
            }
        }
        let pt = Int(self.ticketModel?.total_point ?? "0")
        if pt ?? 0 < firstPoints{
            self.usePvtBtn.isUserInteractionEnabled = false
        }else{
            self.usePvtBtn.isUserInteractionEnabled = true
            self.showUseNow()
            self.usePvtBtn.isSelected = true
        }
        if self.ticketModel?.user_booking ?? 0 == 0{
            self.rewardedString.text = R.string.localizable.youWillBeRewarded(self.onboardingVm.model?.point_accumulation?.first_booking_point ?? "")
        }else{
            self.rewardedString.text = R.string.localizable.youWillBeRewarded(self.onboardingVm.model?.point_accumulation?.bookings ?? "")
        }
    }
    
    func getPrefrenceId(id: String) {
        self.doPayment(id: id)
    }
    
    func bookingSuccess() {
        let vc = ThankyouVC.instance()
        if self.ticketModel?.user_booking ?? 0 == 0{
            vc.points = self.onboardingVm.model?.point_accumulation?.first_booking_point ?? ""
        }else{
            vc.points = self.onboardingVm.model?.point_accumulation?.bookings ?? ""
        }
        vc.name = self.bookingDetails?.name_of_listing ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - STPADDCARD VIEWCONTROLLER DELEGATE
extension SummaryVC : STPAddCardViewControllerDelegate
{
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(token)
        dismiss(animated: false, completion: nil)
        self.makePayment(stripetoken: token)
    }
}



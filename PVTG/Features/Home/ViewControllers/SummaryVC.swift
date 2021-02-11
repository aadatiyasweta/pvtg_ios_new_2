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




class SummaryVC: BaseViewController, GMSMapViewDelegate {
    
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
    var bookingDetails: SessionDetailResult?
    var ticketModel : GetTicketResult?
    var totalTkt = ""
    var sessionTimeId = ""
    var vm = SessionDetailViewModel()
     var mapView:GMSMapView?
    var customModel : CustomBokingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.bookingDelegate = self
      DispatchQueue.main.async {
//            if let sessionImg = SaveToDefaults().getSessionImage(){
//            loadImage(sessionImg, self.imgSession, activity: nil, defaultImage: nil)
//            }
            self.SetMap()
            if let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude(), let dstlat = SaveToDefaults().getSessionLatitude(), let distlng = SaveToDefaults().getSessionLongitude() {
                self.draw(src: CLLocationCoordinate2D(latitude:lat , longitude: lng ), dst: CLLocationCoordinate2D(latitude: dstlat , longitude: distlng ))
            }
       }
        btnAvlblPoints.isUserInteractionEnabled = false
        self.setDta()
        // Do any additional setup after loading the view.
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
    func SetMap(){
        if let lat1 = SaveToDefaults().getLatitude(), let long1 = SaveToDefaults().getLongtitude(){
            let lat = Double(lat1)
            let long = Double(long1)
            let location = CLLocationCoordinate2D(latitude: lat , longitude: long )
            let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long , zoom: 7, bearing: 0,
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
    
    @IBAction func tapPaynow(_ sender: UIButton) {
        var amount = ""
        var points = ""
        var price = 0
        if let tkt = Int(self.totalTkt), let pr = Int(self.ticketModel?.ticket_price ?? "0"){
            price = tkt*pr
            amount = "\(price)"
        }
        if self.usePvtBtn.isSelected{
            
            if Int(self.ticketModel?.total_point ?? "0")! < 300{
                amount = "\(price/2)"
                points = "200"
            }
            else{
                amount = "0"
                points = "300"
            }
        }
      
        self.vm.sessionBookingApi(user_id: self.customModel?.user_id ?? "", session_id: self.customModel?.session_id ?? "", ticket: self.totalTkt, booking_date: self.customModel?.booking_date ?? "", booking_from_time: self.customModel?.booking_from_time ?? "", booking_to_time: self.customModel?.booking_to_time ?? "", paid_amount: amount, schedule_time_id: self.customModel?.schedule_time_id ?? "",points:points )
    }
 
    
    @IBAction func tapUseNow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.vwAdddashedBordr.isHidden = false
            self.btnUseNow.isHidden = false
            if Int(self.ticketModel?.total_point ?? "0")! < 300{
                self.Discount.text = "50 % Discount"
                self.lblPoints.text = "200"
                let val = Int(self.ticketModel?.total_point ?? "0")! - 200
                self.btnAvlblPoints.setTitle("\(val) pts available", for: .normal)
            }else{
                self.Discount.text = "Free"
                self.lblPoints.text = "300"
                let val = Int(self.ticketModel?.total_point ?? "0")! - 300
                self.btnAvlblPoints.setTitle("\(val) pts available", for: .normal)
            }
        }else{
            self.vwAdddashedBordr.isHidden = true
            self.btnUseNow.isHidden = true
            let val = (self.ticketModel?.total_point)!
            self.btnAvlblPoints.setTitle("\(val) pts available", for: .normal)
        }
       
        
    }
    
    
}

extension SummaryVC {
    func setDta() {
        if let name = self.bookingDetails?.name_of_listing, let rating = self.bookingDetails?.rating, let place = self.bookingDetails?.city, let dist = self.bookingDetails?.distance, let price = self.ticketModel?.ticket_price{
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
            let str = place + " (\(doubleStr) km away)"
            self.lblPlacewithDistance.text = str
            self.toatalTickets.text = self.totalTkt
            if let tkt = Int(self.totalTkt), let pr = Int(price){
                self.totalFare.text = "$\(tkt*pr)"

            }
            if pt ?? 0 < 200{
                self.usePvtBtn.isUserInteractionEnabled = false
            }else{
                 self.usePvtBtn.isUserInteractionEnabled = true
            }
            self.btnAvlblPoints.setTitle("\(pt ?? 0) pts available", for: .normal)
            if self.ticketModel?.user_booking ?? 0 == 0{
                self.rewardedString.text = "You will be rewarded 20pts on booking the session"
            }else{
                 self.rewardedString.text = "You will be rewarded 10pts on booking the session"
            }
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
}
extension SummaryVC : GetBookingResponse{
    func bookingSuccess() {
        let vc = ThankyouVC.instance()
        if self.ticketModel?.user_booking ?? 0 == 0{
           vc.points = "20"
        }else{
            vc.points = "10"
        }
        vc.name = self.bookingDetails?.name_of_listing ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
        //
    }
}

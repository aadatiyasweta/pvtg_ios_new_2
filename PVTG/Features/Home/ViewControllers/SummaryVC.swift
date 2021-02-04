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
    var bookingDetails: SessionDetailResult?
    var totalTkt = ""
    var sessionTimeId = ""
    var vm = SessionDetailViewModel()
     var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            _ = CLLocationCoordinate2D(latitude: lat , longitude: long )
            let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long , zoom: 7, bearing: 0,
                                                 viewingAngle: 40)
           mapView = GMSMapView.map(withFrame: self.vwmap.bounds, camera: camera)
           self.vwmap.addSubview(mapView ?? GMSMapView())
           mapView?.delegate = self
               mapView?.isUserInteractionEnabled = true
//           let marker = GMSMarker()
//           let markerImage = UIImage(named: "marker")
//           let markerView = UIImageView(image: markerImage)
//           markerView.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
//           markerView.contentMode = .scaleAspectFit
//           marker.iconView = markerView
//           marker.position = location
//                          marker.map = mapView
           }
       }
    
    @IBAction func tapPaynow(_ sender: UIButton) {
        guard let userid = SaveToDefaults().getUserId(), let sessionId = self.vm.model?.session_id  else {return}
    }
    
    @IBAction func tapUseNow(_ sender: UIButton) {
    }
    
    
}

extension SummaryVC {
    func setDta() {
        if let img = self.bookingDetails?.images?[0], let name = self.bookingDetails?.name_of_listing, let rating = self.bookingDetails?.rating, let place = self.bookingDetails?.city, let dist = self.bookingDetails?.distance, let price = self.vm.availableTickets?.ticket_price, let pt = self.vm.availableTickets?.total_point{
            loadImage(img.session_image ?? "", self.imgSession, activity: nil, defaultImage: nil)
            self.lblSessionNmae.text = name
            self.vwRating.rating = Double(rating)!
            let value = Double(dist) ?? 0.0
            let doubleStr = String(format: "%.2f", value)
            let str = place + " (\(doubleStr) km away)"
            self.lblPlacewithDistance.text = str
            self.toatalTickets.text = self.totalTkt
            if let tkt = Int(self.totalTkt), let pr = Int(price){
                self.totalFare.text = "\(tkt*pr)"

            }
            self.btnAvlblPoints.setTitle("\(pt) pts available", for: .normal)
            
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

              } catch {
                  print("parsing error")
              }
          }
      })
      task.resume()
  }
}

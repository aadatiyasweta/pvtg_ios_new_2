//
//  SessionDetailVC.swift
//  PVTG
//
//  Created by Test Machine on 31/12/20.
//  Copyright © 2020 ShubhamMacmini. All rights reserved.
//

import UIKit
import Cosmos
import FSCalendar
import GoogleMaps

class SessionDetailVC: BaseViewController, GMSMapViewDelegate {
    //MARK:- IBOutlets
    @IBOutlet weak var imgSession: UIImageView!
    @IBOutlet weak var lblsessionPrice: UILabel!
    @IBOutlet weak var lblSessionname: UILabel!
    @IBOutlet weak var lblSessionPlaceName: UILabel!
    @IBOutlet weak var vwrating: CosmosView!
    @IBOutlet weak var lblPlaceName: UILabel!
    
    @IBOutlet weak var vwmap: UIView!
    @IBOutlet weak var lblsessiondetail: UILabel!
    @IBOutlet weak var btnToPrev: UIButton!
    @IBOutlet weak var btnToCurrent: UIButton!
    @IBOutlet weak var btnToNext: UIButton!
    
    @IBOutlet weak var vwcalendar: FSCalendar!{
        didSet {
            self.vwcalendar.dataSource = self
            self.vwcalendar.delegate = self
        }
    }
    
    
    
    @IBOutlet weak var lblDayWithDate: UILabel!
    
    @IBOutlet weak var vwCollection: UICollectionView!{
        didSet {
            vwCollection.dataSource = self
            vwCollection.delegate = self
            vwCollection.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.ident)
        }
    }
    
    @IBOutlet weak var vwbookTickets: UIView!
    
    @IBOutlet weak var lblTicketCount: UILabel!
    
    @IBOutlet weak var vwToGetBlurEffect: UIView!
    
    @IBOutlet weak var vwContainfee: UIView!
    @IBOutlet weak var vwsession: UIView!
    @IBOutlet weak var btnToRemove: UIButton!
    @IBOutlet weak var colectnVwSessionImage: UICollectionView! {
        didSet {
            colectnVwSessionImage.dataSource = self
            colectnVwSessionImage.delegate = self
            colectnVwSessionImage.register(OnboardingCell.nib(), forCellWithReuseIdentifier: OnboardingCell.ident)
        }
    }
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var btndecrease: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    
    @IBOutlet weak var lblNoTime: UILabel!
    
    @IBOutlet weak var VwVendorheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewBotmconstarint: NSLayoutConstraint!
    @IBOutlet weak var lblAboutVendor: UILabel!
    
    @IBOutlet weak var vwMapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwColectionHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var btnBooknow: UIButton!
    @IBOutlet weak var vwCalendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtVw: UITextView!
    
    
    //MARK:- Variables
    var mapView:GMSMapView?
    var monthVal: Int?
    private var currentpage: Date?
    private lazy var today: Date = { return Date()
    }()
    fileprivate let headerFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        return formatter
    }()
    var selectedDate = ""
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var tempTkt = 0
    var yearVal: Int?
    var id = -1
    var sessionId = ""
    var vm = SessionDetailViewModel()
    var timeArr = [AllTimeResult]()
    var controllerId = 0
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if controllerId == 1{
            self.vwmap.isHidden = true
            self.vwcalendar.isHidden = true
            self.vwCollection.isHidden = true
            self.vwColectionHeightConstarint.constant = 0
            self.vwMapHeightConstraint.constant = 0
            self.vwCalendarHeightConstraint.constant = 0
            self.lblDayWithDate.isHidden = true
            self.lblNoTime.isHidden = true
            loadApi(top_search: "")
        } else if controllerId == 2 {
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = false
            self.vwCollection.isHidden = false
            self.vwColectionHeightConstarint.constant = 70
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 300
            self.lblDayWithDate.isHidden = false
            self.lblNoTime.isHidden = false
            loadApi(top_search: "1")
        }else if controllerId == 3 {
            self.vwmap.isHidden = true
            self.vwcalendar.isHidden = true
            self.vwCollection.isHidden = true
            self.vwColectionHeightConstarint.constant = 0
            self.vwMapHeightConstraint.constant = 0
            self.vwCalendarHeightConstraint.constant = 0
            self.lblDayWithDate.isHidden = true
            self.lblNoTime.isHidden = true
            self.btnBooknow.isHidden = true
            loadApi(top_search: "")
        }else {
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = false
            self.vwCollection.isHidden = false
            self.vwColectionHeightConstarint.constant = 70
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 300
            self.lblDayWithDate.isHidden = false
            self.lblNoTime.isHidden = false
            loadApi(top_search: "")
        }
        vm.delegate = self
        
        setuptimer()
        handlingHeaderInFSCalendar()
    }
    
    func SetMap(){
        if let lat1 = self.vm.model?.latitude, let long1 = self.vm.model?.longitude{
            let lat = Double(lat1)
            let long = Double(long1)
            let location = CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: long ?? 0.0)
            let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0.0, longitude: long ?? 0.0, zoom: 5, bearing: 0,
                                              viewingAngle: 40)
        mapView = GMSMapView.map(withFrame: self.vwmap.bounds, camera: camera)
        self.vwmap.addSubview(mapView ?? GMSMapView())
        mapView?.delegate = self
            mapView?.isUserInteractionEnabled = false
        let marker = GMSMarker()
        let markerImage = UIImage(named: "marker")
        let markerView = UIImageView(image: markerImage)
        markerView.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
        markerView.contentMode = .scaleAspectFit
        marker.iconView = markerView
        marker.position = location
                       marker.map = mapView
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if controllerId == 1{
            self.btnBooknow.setTitle("Cancel", for: .normal)
        }else {
            self.btnBooknow.setTitle("BOOK NOW", for: .normal)
            if id == -1 {
                showAlert(strTitle: "Please Select time")
            } else {
                self.vwbookTickets.animShow()
                self.vwToGetBlurEffect.addBlurEffect()
                self.btnToRemove.isHidden = false
                
            }
        }
    }
    
    @IBAction func btnToTapPrev(_ sender: UIButton) {
        moveCurrentpage(value: true)
    }
    
    @IBAction func btnTotapCurrent(_ sender: UIButton) {
    }
    
    @IBAction func btnToTapNext(_ sender: UIButton) {
        moveCurrentpage(value: false)
    }
    @IBAction func btnReduceTicketTap(_ sender: UIButton) {
        if self.lblTicketCount.text == "01"{
            btndecrease.isUserInteractionEnabled = false
        } else {
            let deccount = (Int(self.lblTicketCount.text ?? "01") ?? 0)-1
            self.lblTicketCount.text = String(format: "%02d", deccount)
            self.btnIncrease.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func btnIncreaseTicketTap(_ sender: UIButton) {
        var count = (Int(lblTicketCount.text ?? "01") ?? 0)
        if count == Int(self.vm.availableTickets?.ticket_avilable ?? "") {
            self.btndecrease.isUserInteractionEnabled = true
            self.btnIncrease.isUserInteractionEnabled = false
        } else {
            count = (Int(lblTicketCount.text ?? "00") ?? 0)+1
        }
        
        self.lblTicketCount.text = String(format: "%02d", count)
    }
    
    @IBAction func btnContinueTap(_ sender: UIButton) {
        btnToRemove.isHidden = true
        bookingApi()
    }
    
    @IBAction func btnTapToRemoveFromSuperview(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.vwbookTickets.animHide()
            self.btnToRemove.isHidden = true
            self.vwToGetBlurEffect.removeBlurEffect()
        }
    }
}

extension SessionDetailVC: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    private func moveCurrentpage(value: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = value ? -1 : 1
        self.currentpage = calendar.date(byAdding: dateComponents, to: self.currentpage ?? self.today)
        self.vwcalendar.setCurrentPage(self.currentpage ?? Date(), animated: true)
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setHeaderMonth(date: calendar.currentPage.toLocalTime())
    }
    private func setHeaderMonth(date:Date) {
        let calendar = Calendar.current
        yearVal = calendar.component(.year, from: date)
        monthVal = calendar.component(.month, from: date)
        self.currentpage = date
        let current = date
        let prev = calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
        let next = calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
        btnToCurrent.setTitle("\(headerFormatter.string(from: current))", for: .normal)
        btnToNext.setTitle("\(headerFormatter.string(from: next))", for: .normal)
        btnToPrev.setTitle("\(headerFormatter.string(from: prev))", for: .normal)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        debugPrint("Api for getting time")
        self.formatter.dateFormat = "yyyy-MM-dd"
        print("did select date \(self.formatter.string(from: date))")
        self.selectedDate = "\(self.formatter.string(from: date))"
        self.lblDayWithDate.text = stringconvertIntoHourFormatted(inputDate:  self.selectedDate)
        guard let alldate = self.vm.model?.all_date else {return}
        for val in alldate {
            if selectedDate == val.schedule_date{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if val.is_avilable == "1" {
                    self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId)
                    self.scrollViewBotmconstarint.constant = 97
                    }
                }
                
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                }, completion: nil)
                
            }
        }
        
        self.vwCollection.reloadData()
        self.colectnVwSessionImage.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,eventDefaultColorsFor date: Date) -> [UIColor]? {
        self.formatter.dateFormat = "yyyy-MM-dd"
        let strDate = "\(self.formatter.string(from: date))"
        guard let data = self.vm.model?.all_date else {return [.white]}
        debugPrint(data)
        debugPrint(strDate)
        for allDate in data{
            if allDate.schedule_date == strDate{
                if allDate.is_avilable=="1"{
                    return [.green]
                } else {
                    return [.red]
                }
            }
            
        }
        return [.white]
    }
}

extension Date {
    func toLocalTime()->Date
    {
        let tz:NSTimeZone = NSTimeZone.default as NSTimeZone
        let seconds:TimeInterval = TimeInterval(tz.secondsFromGMT(for: self as Date))
        return Date(timeInterval: seconds, since: self as Date)
    }
}

extension SessionDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==colectnVwSessionImage{
            return self.vm.model?.images?.count ?? 0
        }else {
            return self.timeArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.timeArr.count == 0 {
            self.lblNoTime.isHidden = false
            self.lblNoTime.text = "No available time for date."
        } else {
            self.lblNoTime.isHidden = true
            self.lblNoTime.text = ""
            
        }
        
        if collectionView==vwCollection {
            var remainingTkt = 0
            if  let totalTkt = Int(self.timeArr[indexPath.row].total_ticket ?? ""), let soldTkt = Int(self.timeArr[indexPath.row].sold_ticket ?? "") {
                remainingTkt =  totalTkt-soldTkt
                SaveToDefaults().setremainingTkt(tkt: "\(remainingTkt)")
                lblTicketCount.text = "01"
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
            if self.timeArr[indexPath.row].is_avilable_time == "0" {
                cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
               // cell.vwContainCatgry.alpha = 0.7
                cell.vwContainCatgry.layer.cornerRadius = 10
            } else {
                if id == indexPath.row {
                    cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 0.7411764706, alpha: 1)
                } else {
                    cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
                }
                cell.vwContainCatgry.layer.cornerRadius = 10
            }
            
            cell.layoutSubviews()
            cell.setData(data: self.timeArr[indexPath.row])
            return cell
        } else {
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.ident, for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
            cell1.imgDetailView.isHidden = false
            cell1.lblInfo.isHidden = true
            cell1.descLabel.isHidden = true
            loadImage(self.vm.model?.images?[indexPath.row].session_image ?? "", cell1.imgDetailView, activity: nil, defaultImage: nil)
            return cell1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView==self.vwCollection {
            return CGSize(width: 65, height: 65)
        } else {
            return CGSize(width: self.colectnVwSessionImage.frame.width, height: self.colectnVwSessionImage.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.vwCollection{
        if self.id == indexPath.row{
            self.id = -1
        } else {
            self.id = indexPath.row
            guard let userid = SaveToDefaults().getUserId() else { return}
            self.vm.getTicketDataApi(user_id: userid, session_id: sessionId, schedule_time_id: self.timeArr[id].schedule_time_id ?? "")
        }
        self.vwCollection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView==self.colectnVwSessionImage {
            self.pageCtrl.numberOfPages = self.vm.model?.images?.count ?? 0
        }
    }
    
    
}

extension SessionDetailVC: GetResponse {
    func allTicketsSold() {
        self.btnToRemove.isHidden = false
    }
    
    
    func bookingSuccess() {
        self.vwbookTickets.isHidden = true
        self.btnToRemove.isHidden = true
        self.vwToGetBlurEffect.removeBlurEffect()
        let vc = SummaryVC.instance()
            vc.bookingDetails = self.vm.model
            vc.totalTkt = self.lblTicketCount.text ?? ""
            vc.sessionTimeId = "\(self.id)"
            self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.SetMap()
        }

        self.timeArr = self.vm.timeArr?.result ?? Array()
        if self.timeArr.count == 0 {
            self.btnBooknow.isHidden = true
            self.scrollViewBotmconstarint.constant = 0
        } else {
            self.btnBooknow.isHidden = false
            self.scrollViewBotmconstarint.constant = 97
        }
        guard let data = self.vm.model, let lat1 = self.vm.model?.latitude, let lang1 = self.vm.model?.longitude else {return}
        if data.bio == "" {
            self.lblAboutVendor.text = ""
            self.VwVendorheightConstraint.constant = 0
        } else {
            self.lblAboutVendor.text = "About Vendor"
            self.VwVendorheightConstraint.constant = 150
        }
        if self.vm.timeArr?.result?.count == 0 {
            self.lblNoTime.isHidden = true
            self.lblNoTime.text = ""
        } else {
            self.lblNoTime.isHidden = false
            self.lblNoTime.text = "No available time for date."
        }
        let value = Double(data.distance ?? "")!
        let doubleStr = String(format: "%.2f", value)
        let str = (data.city ?? "") + " (\(doubleStr) km)"
        self.lblsessionPrice.text = "$"+(data.ticket_price ?? "")
        self.lblSessionname.text = data.category_name ?? ""
        self.vwrating.rating = Double(data.rating ?? "")!
        self.lblPlaceName.text = str
        if data.bio == "" {
            self.VwVendorheightConstraint.constant = 0
        } else {
            self.VwVendorheightConstraint.constant = 150
            self.txtVw.text = data.bio
        }
        let lat = Double(lat1); let lng = Double(lang1)
        SaveToDefaults().seSessiontLatitude(lat: lat)
        SaveToDefaults().seSessiontLongitude(lat: lng)
        //        self.lblDayWithDate.text = convertIntoHourFormatted(inputDate: data.all_date?[0].schedule_date ?? "")
        self.lblSessionPlaceName.text = data.name_of_listing
        self.lblsessiondetail.text = data.description
        self.vwCollection.reloadData()
        self.vwcalendar.reloadData()
        self.colectnVwSessionImage.reloadData()
    }
    
    
}

extension SessionDetailVC {
    //MARK:- Function to automatic Scroll
    private func setuptimer() {
        _ = Timer.scheduledTimer(timeInterval: 3, target: self , selector:
            #selector(startScrolling), userInfo: nil, repeats: true)
        
    }
    
    @objc func startScrolling() {
        
        if self.pageCtrl.currentPage == self.pageCtrl.numberOfPages - 1 {
            pageCtrl.currentPage = 0
        } else {
            pageCtrl.currentPage += 1
        }
        self.vwCollection.scrollToItem(at: IndexPath(row: pageCtrl.currentPage, section: 0), at: .right, animated: true)
    }
    
    //UIScrollView INT TO COUNT
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageCtrl.currentPage =  Int(pageNumber)
    }
    
    //Api Integration
    private func loadApi(top_search: String) {
        guard let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  else {return}
        self.vm.sessionDtailApi(user_id: userid, session_id: sessionId, latitude: "\(lat)", longitude: "\(lng)", top_search: top_search)
        guard let alldate = self.vm.model?.all_date else {return}
        self.formatter.dateFormat = "yyyy-MM-dd"
               for val in alldate {
                if self.formatter.string(from: self.today) == val.schedule_date{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId)
                    self.scrollViewBotmconstarint.constant = 97
                }
                
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                }, completion: nil)
                
            }
        }
        
    }
    private func bookingApi() {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if let id = self.vm.model?.session_id, let amt = self.vm.model?.ticket_price, let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  {
            self.vm.checkTicketAvailabilityApi(user_id: userid, session_id: id, latitude: "\(lat)", longitude: "\(lng)", ticket: self.lblTicketCount.text ?? "", booking_date: self.selectedDate, booking_from_time: "\(self.vm.timeArr?.result?[self.id].from_time ?? "0")", booking_to_time: "\(self.vm.timeArr?.result?[self.id].to_time ?? "0")", paid_amount: amt, schedule_time_id: "\(self.vm.timeArr?.result?[self.id].schedule_time_id ?? "0")")
            }
//            self.vm.sessionBookingApi(user_id: userid, session_id: id, ticket: "\(tempTkt)", booking_date: self.selectedDate, booking_from_time: fromtime, booking_to_time: toTime, paid_amount: amt, schedule_time_id: timeId)
        }
    
    
    //Customization Of view
    private func customizationOfView(){
        DispatchQueue.main.async {
            setRightShadow(view: self.vwContainfee, color: #colorLiteral(red: 0.4522080421, green: 0.4990295768, blue: 0.8806897998, alpha: 1), opacity: 0.7, width: 5, height: 4)
            setRightShadowWithOffset(view: self.vwsession, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.2, width: 5, height: 5, offsetX: 10, offsetY: 20)
            // setRightShadow(view: self.vwsession, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.7, width: 5, height: 555)
            
        }
    }
    
    //Function To handle the current year montrh date in FsCalendar
    private func handlingHeaderInFSCalendar() {
        let date = Date()
        setHeaderMonth(date:date)
        customizationOfView()
        self.lblDayWithDate.text = convertIntoHourFormatted(inputDate: self.today)
    }
    
}

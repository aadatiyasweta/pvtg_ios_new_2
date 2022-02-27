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
import AVFoundation
import AVKit

class SessionDetailVC: BaseViewController, GMSMapViewDelegate {
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var bookingDateLbl: UILabel!
    @IBOutlet weak var offeredHeightCons: NSLayoutConstraint!
    @IBOutlet weak var offerdView: UIView!
    @IBOutlet weak var offeredCollView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var mainScrollview: UIScrollView!
    @IBOutlet weak var imgSession: UIImageView!
    @IBOutlet weak var lblsessionPrice: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var lblSessionname: UILabel!
    @IBOutlet weak var lblSessionPlaceName: UILabel!
    @IBOutlet weak var vwrating: CosmosView!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vwmap: UIView!
    @IBOutlet weak var lblsessiondetail: UILabel!
    @IBOutlet weak var btnToPrev: UIButton!
    @IBOutlet weak var btnToCurrent: UIButton!
    @IBOutlet weak var btnToNext: UIButton!
    
    @IBOutlet weak var aboutViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var vwcalendar: FSCalendar!{
        didSet {
            self.vwcalendar.dataSource = self
            self.vwcalendar.delegate = self
        }
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var completedBtn: UIButton!
    
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
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var btnToRemove: UIButton!
    
    @IBOutlet weak var vwcontainTktCount: UIView!
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
    
    @IBOutlet weak var scrollViewBotmconstarint: NSLayoutConstraint!
    @IBOutlet weak var lblAboutVendor: UILabel!
    
    @IBOutlet weak var vwMapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwColectionHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var btnBooknow: UIButton!
    @IBOutlet weak var vwCalendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtVw: UILabel!
    
    
    //MARK:- Variables
    var x = 1
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
     let formatter: DateFormatter = {
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
    var timer : Timer?
    var isFromSelection = false
    var offeredIndex = -1
    var bookingId = ""
    var arrPayments = [GetAllPaymentDetailsData]()
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//     self.tabBarController?.tabBar.addBadge(index: 3)
        self.mainScrollview.delegate = self
         vwcalendar.appearance.todayColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
        vwcalendar.appearance.todaySelectionColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
        self.selectedDate = formatter.string(from: self.today)
        offeredCollView.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.ident)
        if controllerId == 1{
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = true
            self.vwCollection.isHidden = true
            self.vwColectionHeightConstarint.constant = 0
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 0
            self.lblDayWithDate.isHidden = true
            self.lblNoTime.isHidden = true
            self.btnBooknow.isHidden = true
         self.priceLabel.isHidden = true
//            self.lblsessionPrice.isHidden = true
            self.cancelBtn.isHidden = false
            self.completedBtn.isHidden = true
        } else if controllerId == 2 {
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = false
            self.vwCollection.isHidden = false
            self.vwColectionHeightConstarint.constant = 70
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 300
            self.lblDayWithDate.isHidden = false
            self.lblNoTime.isHidden = false
             self.btnBooknow.isHidden = true
         self.priceLabel.isHidden = true
//            self.lblsessionPrice.isHidden = true
            self.cancelBtn.isHidden = true
            self.completedBtn.isHidden = true
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
         self.priceLabel.isHidden = true
//            self.lblsessionPrice.isHidden = true
            self.cancelBtn.isHidden = true
            self.completedBtn.isHidden = true
        }else {
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = false
            self.vwCollection.isHidden = false
            self.vwColectionHeightConstarint.constant = 70
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 300
            self.lblDayWithDate.isHidden = false
            self.lblNoTime.isHidden = false
            self.btnBooknow.isHidden = false
            self.cancelBtn.isHidden = true
            self.completedBtn.isHidden = true
         self.priceLabel.isHidden = false
//            self.lblsessionPrice.isHidden = false
        }
        loadApi(top_search: "")
        vm.delegate = self
        handlingHeaderInFSCalendar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.vwcontainTktCount, opacity: 0.12)
       // setVSViewShadow(radius: 10, color: .black, view: self.vwcontainTktCount, opacity: 0.12)
    }

    func SetMap(){
        if let lat1 = self.vm.model?.latitude, let long1 = self.vm.model?.longitude{
            let lat = Double(lat1)
            let long = Double(long1)
            let location = CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: long ?? 0.0)
            let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0.0, longitude: long ?? 0.0, zoom: 15, bearing: 0,
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
        if id == -1 {
            showAlert(strTitle: R.string.localizable.pleaseSelecttime())
        } else {
            self.vwbookTickets.animShow()
            self.vwToGetBlurEffect.addBlurEffect()
            self.btnToRemove.isHidden = false
            
        }
    }
    
    
    @IBAction func cancelBtnTap(_ sender: UIButton) {
        showAlertWithConfirmation2(R.string.localizable.cancelTheBooking(), withTitle: Bundle.main.appName, itsController: self) { (succsss) in
            if succsss{
                let time = self.vm.model?.booking_date ?? ""
                let fromattter1 = DateFormatter()
                fromattter1.dateFormat = "yyyy-MM-dd HH:mm"
                fromattter1.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
                let endDate = fromattter1.date(from: time) ?? Date()
                let hours = getMinutesDifferenceFromTwoDates(start: getCurrentLocalDate(), end: endDate).hour ?? 0
                if hours < 2{
                    if let id = SaveToDefaults().getUserId(){
                        let ammount = self.vm.model?.paid_amount ?? ""
                        if let n = NumberFormatter().number(from: ammount) {
                          let floatPrice = CGFloat(truncating: n)
                            let fiftenPercent = CGFloat((floatPrice*15)/100)
                            let finalPrice = floatPrice-fiftenPercent
                            self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: true, paymentId: self.vm.model?.payment_id ?? "", ammount: "\(finalPrice)")
                        }
                    }
                }else{
                    if let id = SaveToDefaults().getUserId(){
                        self.vm.sessionCancelApi(user_id: id, session_id: self.sessionId, booking_id: self.bookingId, isFromPartial: false, paymentId: self.vm.model?.payment_id ?? "", ammount: self.vm.model?.paid_amount ?? "")
                    }
                    
                }
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
           // self.btnIncrease.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func btnIncreaseTicketTap(_ sender: UIButton) {
        var count = (Int(lblTicketCount.text ?? "01") ?? 0)
        self.btndecrease.isUserInteractionEnabled = true
        if count == Int(self.vm.availableTickets?.ticket_avilable ?? "") {
            
           // self.btnIncrease.isUserInteractionEnabled = false
            if count > 1{
                showAlert(strTitle: R.string.localizable.onlyTickets("\(count)"))
            }else
            {
                showAlert(strTitle: R.string.localizable.onlyTicket("\(count)"))
            }
            
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
     let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.month = value ? -1 : 1
        self.currentpage = calendar.date(byAdding: dateComponents, to: self.currentpage ?? self.today)
        self.vwcalendar.setCurrentPage(self.currentpage ?? Date(), animated: true)
        
    }
 
   func minimumDate(for calendar: FSCalendar) -> Date {
     return Date()
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setHeaderMonth(date: calendar.currentPage.toLocalTime())
    }
    private func setHeaderMonth(date:Date) {
     let calendar = Calendar(identifier: .gregorian)
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
 

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if date.compare(Date.yesterday) == .orderedAscending {
            return false
        }
        else {
            return true
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.isFromSelection = true
        debugPrint("Api for getting time")
        self.formatter.dateFormat = "yyyy-MM-dd"
        print("did select date \(self.formatter.string(from: date))")
        self.selectedDate = "\(self.formatter.string(from: date))"
        self.lblDayWithDate.text = stringconvertIntoHour(inputDate:  self.selectedDate)
        guard let alldate = self.vm.model?.all_date else {return}
        for val in alldate {
            if selectedDate == val.schedule_date{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if val.is_avilable == "1" {
                        self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: true)
                    self.scrollViewBotmconstarint.constant = 97
                    }
                }
                
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                 self.priceLabel.isHidden = true
//                  self.lblsessionPrice.isHidden = true
                }, completion: nil)
                
            }
        }
        
        self.vwCollection.reloadData()
        self.colectnVwSessionImage.reloadData()
    }
    
    func stringconvertIntoHour(inputDate: String)-> String {
        let dateAsString = inputDate
        let dateFormatter = self.formatter
        var Date24 = ""
        
        if let date1 = dateFormatter.date(from: dateAsString){
        debugPrint("Date is \(date)")
            debugPrint("date is \(date1)")
        dateFormatter.dateFormat = "EEEE, MMMM d"
        Date24 = dateFormatter.string(from: date1 )
        }
        debugPrint("24 hour formatted Date:",Date24)
        
        return Date24
        
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
        }else if collectionView == self.offeredCollView{
            return self.vm.model?.session_type?.count ?? 0
        }
        return self.timeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(self.timeArr.count)
        print(vwCollection.isHidden)
        if self.controllerId == 0 || self.controllerId == 2{
            if self.timeArr.count == 0 {
                self.lblNoTime.isHidden = false
                self.lblNoTime.text = R.string.localizable.noAvailableTimeFordate()
            } else {
                self.lblNoTime.isHidden = true
                self.lblNoTime.text = ""
                
            }
        }
        else{
           self.lblNoTime.isHidden = true
        }
        
        if collectionView == self.vwCollection {
   
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
            
          //  cell.layoutSubviews()
            cell.setData(data: self.timeArr[indexPath.row])
            return cell
        }
        else if collectionView == self.offeredCollView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
            cell.searchCategorylbl.text = self.vm.model?.session_type?[indexPath.row].session_type
            if offeredIndex != -1{
//                self.lblsessionPrice.text = "\(self.vm.model?.session_type?[offeredIndex].price ?? "" ) \(self.vm.model?.currency ?? "")"
             
             let myDouble  = Double(self.vm.model?.session_type?[offeredIndex].price ?? "") ?? 0.0
//             let myDouble = Double(12000)
             
             let currencyFormatter = NumberFormatter()
             currencyFormatter.usesGroupingSeparator = true
             currencyFormatter.numberStyle = .currency
//             currencyFormatter.currencyCode = "COP"
             currencyFormatter.locale = Locale.current

            let  priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
            
            
             let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
             if let currency = self.vm.model?.currency {
              self.priceLabel.text = replaced + " " +  currency
             }
//             self.priceLabel.text = "\(self.vm.model?.session_type?[offeredIndex].price ?? "" ) \(self.vm.model?.currency ?? "")"
            }
           
            if offeredIndex == indexPath.row {
                cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 0.7411764706, alpha: 1)
            } else {
                cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
            }
            cell.vwContainCatgry.layer.cornerRadius = 10
            
            return cell
        }
        else {
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.ident, for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
            cell1.imgDetailView.isHidden = false
            cell1.lblInfo.isHidden = true
            cell1.descLabel.isHidden = true
            self.setuptimer()
            if self.vm.model?.images?[indexPath.row].type ?? "" == "image"{
                 cell1.playBtn.isHidden = true
             loadImage(self.vm.model?.images?[indexPath.row].session_image ?? "", cell1.imgDetailView, activity: nil, defaultImage: nil)
            }else{
                 cell1.playBtn.isHidden = false
                loadImage(self.vm.model?.images?[indexPath.row].image_thumbnail ?? "", cell1.imgDetailView, activity: nil, defaultImage: nil)
            }
            cell1.playcall = {
                self.presentAvplayerController(url: self.vm.model?.images?[indexPath.row].session_image ?? "")
            }
            return cell1
        }
        
    }
    func presentAvplayerController(url : String){
           if let videoURL = URL(string: url){
               let player = AVPlayer(url: videoURL)
               let playerViewController = AVPlayerViewController()
               playerViewController.player = player
               do {
                   try AVAudioSession.sharedInstance().setCategory(.playback)
               } catch(let error) {
                   print(error.localizedDescription)
               }
               self.present(playerViewController, animated: true) {
                   playerViewController.player!.play()
               }
           }
           
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView==self.vwCollection {
            return CGSize(width: 150, height: 55)
        }
        else if collectionView==self.offeredCollView{
            let text = self.vm.model?.session_type?[indexPath.row].session_type
            let label = UILabel(frame: CGRect.zero)
            label.text = text
            label.sizeToFit()
            return CGSize(width: label.frame.size.width+22, height: 55)
        }
        else {
            return CGSize(width: SCREEN_WIDTH, height: self.colectnVwSessionImage.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.vwCollection{
        if self.id == indexPath.row{
           // self.id = -1
        } else {
            self.id = indexPath.row
            guard let userid = SaveToDefaults().getUserId() else { return}
            self.vm.getTicketDataApi(user_id: userid, session_id: sessionId, schedule_time_id: self.timeArr[id].schedule_time_id ?? "")
        }
        self.vwCollection.reloadData()
        }else if collectionView == self.offeredCollView{
            self.offeredIndex = indexPath.row
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView==self.colectnVwSessionImage {
            self.pageCtrl.numberOfPages = self.vm.model?.images?.count ?? 0
            self.pageCtrl.currentPage = indexPath.row
        }
    }
}

extension SessionDetailVC: GetResponse {
    func refundAPiResponse(){
        self.navigationController?.popViewController(animated: true)
    }
    func sessionTimeDetail(){
        self.timeArr = self.vm.timeArr?.result ?? []
        if self.controllerId != 1{
            if self.timeArr.count == 0 {
                self.btnBooknow.isHidden = true
//                self.lblsessionPrice.isHidden = true
             self.priceLabel.isHidden = true
                self.scrollViewBotmconstarint.constant = 0
            } else {
                self.btnBooknow.isHidden = false
             self.priceLabel.isHidden = false
//                self.lblsessionPrice.isHidden = false
                self.scrollViewBotmconstarint.constant = 97
                if  self.isFromSelection{
                    let bottomOffset = CGPoint(x: 0, y: self.mainScrollview.contentSize.height - mainScrollview.bounds.height + mainScrollview.contentInset.bottom)
                    mainScrollview.setContentOffset(bottomOffset, animated: true)
                }
            }
        }
        self.vwCollection.reloadData()
        self.offeredCollView.reloadData()
    }
    func reloadTime() {
        guard let alldate = self.vm.model?.all_date else {return}
        self.formatter.dateFormat = "yyyy-MM-dd"
        for val in alldate {
            if self.formatter.string(from: self.today) == val.schedule_date && val.is_avilable ?? "0" == "1"{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: false)
                    self.scrollViewBotmconstarint.constant = 97
                }
                break
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.scrollViewBotmconstarint.constant = 0
                    //self.btnBooknow.isHidden = true
                }, completion: nil)
                
            }
        }
    }
    
    func allTicketsSold() {
        showAlert(strTitle: R.string.localizable.noticketavailable())
        self.btnToRemove.isHidden = false
    }
    
    
    func bookingSuccess() {
        self.vwbookTickets.isHidden = true
        self.btnToRemove.isHidden = true
        self.vwToGetBlurEffect.removeBlurEffect()
        let vc = SummaryVC.instance()
        vc.bookingDetails = self.vm.model
        vc.totalTkt = self.lblTicketCount.text ?? ""
        vc.ticketModel = self.vm.availableTickets
        vc.customModel = self.vm.customModel
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    func reloadData() {
         
        DispatchQueue.main.async {
            
            self.SetMap()
        }
        self.timeArr = self.vm.timeArr?.result ?? Array()
        if self.controllerId != 1{
            if self.timeArr.count == 0 {
                self.btnBooknow.isHidden = true
               self.priceLabel.isHidden = true
//                self.lblsessionPrice.isHidden = true
                self.scrollViewBotmconstarint.constant = 0
            } else {
                self.btnBooknow.isHidden = false
             self.priceLabel.isHidden = false
//                self.lblsessionPrice.isHidden = false
                self.scrollViewBotmconstarint.constant = 97
            }
        }
        
        guard let data = self.vm.model, let lat1 = self.vm.model?.latitude, let lang1 = self.vm.model?.longitude else {return}
        if data.booking_date ?? "" == ""{
            self.bookingDateLbl.text = ""
        }else{
            self.bookingDateLbl.text = "\(R.string.localizable.bookingdate()) \(changeDateFormatForReminder(date: data.booking_date ?? "", fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd MMM yyyy hh:mm a"))"
        }
        if data.bio == "" {
            self.lblAboutVendor.text = ""
            self.aboutViewBottomCons.constant = 0
            self.aboutView.isHidden = true
            vendorNameLbl.text = data.vendorName ?? ""
        } else {
            self.lblAboutVendor.text = R.string.localizable.aboutVendor()
            vendorNameLbl.text = data.vendorName ?? ""
            self.aboutViewBottomCons.constant = 22
            self.aboutView.isHidden = false
        }
        if self.vm.timeArr?.result?.count == 0 {
            self.lblNoTime.isHidden = true
            self.lblNoTime.text = ""
        } else {
            self.lblNoTime.isHidden = false
            self.lblNoTime.text = R.string.localizable.noAvailableTimeFordate()
        }
        self.vm.sessionName =  data.name_of_listing ?? ""
        self.vm.sessionDesc = data.description ?? ""
        let value = Double(data.distance ?? "")!
        let doubleStr = String(format: "%.2f", value)
        let str = (data.city ?? "") + " " + R.string.localizable.kmaway(doubleStr)
//        self.lblsessionPrice.text = (data.currency ?? "$")+(data.ticket_price ?? "")
        self.lblSessionname.text = data.category_name ?? ""
        self.vwrating.rating = Double(data.rating ?? "")!
        self.lblPlaceName.text = str
        self.txtVw.text = data.bio
        self.languageLbl.text = data.session_language
        let lat = Double(lat1); let lng = Double(lang1)
        SaveToDefaults().seSessiontLatitude(lat: lat)
        SaveToDefaults().seSessiontLongitude(lat: lng)
        //        self.lblDayWithDate.text = convertIntoHourFormatted(inputDate: data.all_date?[0].schedule_date ?? "")
        self.lblSessionPlaceName.text = data.name_of_listing
        self.lblsessiondetail.text = data.description
        if self.vm.model?.session_type?.count ?? 0 == 0{
            self.offerdView.isHidden = true
            self.offeredHeightCons.constant = 0
            self.offeredIndex = -1
        }else{
//            for value in 0..<(self.vm.model?.session_type!.count)!{
//                if self.vm.model?.session_type?[value].session_type_id == self.vm.model?.booking_session_type{
//                    self.vm.model?.session_type = [self.vm.model?.session_type?[value]]
//                    self.offeredIndex = 0
//                    break
//                }
//            }
            if self.offeredIndex == -1{
                self.offeredIndex = 0
            }
            self.offerdView.isHidden = false
            self.offeredHeightCons.constant = 116
            
        }
        self.vwCollection.reloadData()
     if(data.session_booking_status == "2" ||  data.session_booking_status == "3"){
      self.cancelBtn.isEnabled = false
      self.cancelBtn.setTitle("Cancelled", for: .normal)
     }else {
      self.cancelBtn.isEnabled = true
      self.cancelBtn.setTitle("Cancel", for: .normal)
     }
        self.vwcalendar.reloadData()
        self.colectnVwSessionImage.reloadData()
        self.offeredCollView.reloadData()
        self.timer?.invalidate()
        setuptimer()
        guard let alldate = self.vm.model?.all_date else {return}
        self.formatter.dateFormat = "yyyy-MM-dd"
        for val in alldate {
            if self.formatter.string(from: self.today) == val.schedule_date && val.is_avilable ?? "0" == "1"{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if self.controllerId == 0 || self.controllerId == 2{
                        self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: false)
                        self.scrollViewBotmconstarint.constant = 97
                    }
                }
                break
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                }, completion: nil)
                
            }
        }
     self.getAllPaymentDetails()
    }
   
 //MARK: - METHOD TO GET ALL PAYMENT DETAILS
 
 func getAllPaymentDetails() {
  if let userid = SaveToDefaults().getUserId(){
   vm.getAllPayments(user_id: userid){
    if let arrPayments = self.vm.arrPayments {
     self.arrPayments = arrPayments
     let dict =   self.arrPayments .filter{ ($0.session_id!) == self.sessionId }.first
     if let dict = dict{
      self.vm.chargeId = dict.charge_id ?? ""
     }
    }
   }
  }
  
 }}

extension SessionDetailVC {
    //MARK:- Function to automatic Scroll
    private func setuptimer() {
       // self.timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector:
        //    #selector(startScrolling), userInfo: nil, repeats: true)
        
    }
    
    @objc func startScrolling() {
        if self.x < self.vm.model?.images?.count ?? 0 {
            let indexPath = IndexPath(item: x, section: 0)
            self.vwCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
        }else{
            self.x = 0
            self.vwCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    
    }
    
    //UIScrollView INT TO COUNT
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colectnVwSessionImage{
             self.timer?.invalidate()
             self.timer = nil
        }
        else if scrollView == self.mainScrollview{
            print(scrollView.contentOffset.y)
            if scrollView.contentOffset.y  < 0{
                scrollView.contentOffset.y = 0
                self.backBtn.isHidden = false
            }else{
                if scrollView.contentOffset.y > 55 {
                    self.backBtn.isHidden = true
                }else{
                    self.backBtn.isHidden = false
                }
            }
        }
    }
    
    //Api Integration
    private func loadApi(top_search: String) {
        guard let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  else {return}
        self.vm.sessionDtailApi(user_id: userid, session_id: sessionId, latitude: "\(lat)", longitude: "\(lng)", top_search: top_search,bookingId: self.bookingId)
        
    }
    private func bookingApi() {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if let id = self.vm.model?.session_id, let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  {
            var amt = ""
            var offeredTypeId = ""
            if self.offeredIndex != -1{
                offeredTypeId = self.vm.model?.session_type?[self.offeredIndex].session_type_id ?? ""
                amt = self.vm.model?.session_type?[self.offeredIndex].price ?? ""
            }else{
                return
            }
            self.vm.checkTicketAvailabilityApi(user_id: userid, session_id: id, latitude: "\(lat)", longitude: "\(lng)", ticket: self.lblTicketCount.text ?? "", booking_date: self.selectedDate, booking_from_time: "\(self.vm.timeArr?.result?[self.id].from_time ?? "0")", booking_to_time: "\(self.vm.timeArr?.result?[self.id].to_time ?? "0")", paid_amount: amt, schedule_time_id: "\(self.vm.timeArr?.result?[self.id].schedule_time_id ?? "0")", offeredTypeId: offeredTypeId)
            }
//            self.vm.sessionBookingApi(user_id: userid, session_id: id, ticket: "\(tempTkt)", booking_date: self.selectedDate, booking_from_time: fromtime, booking_to_time: toTime, paid_amount: amt, schedule_time_id: timeId)
        }
    
    
    //Customization Of view
    private func customizationOfView(){
        DispatchQueue.main.async {
            setRightShadow(view: self.vwContainfee, color: #colorLiteral(red: 0.4522080421, green: 0.4990295768, blue: 0.8806897998, alpha: 1), opacity: 0.7, width: 5, height: 4)
            setRightShadowWithOffset(view: self.vwsession, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.2, width: 5, height: 5, offsetX: 10, offsetY: 20)
            setRightShadowWithOffset(view: self.langView, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.2, width: 5, height: 5, offsetX: 10, offsetY: 20)
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
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

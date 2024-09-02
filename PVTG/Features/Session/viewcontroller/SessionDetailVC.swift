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
    
    //MARK: - Outlets
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
    
    @IBOutlet weak var serviceTimeCollectionVw: UICollectionView!
    @IBOutlet weak var vwcalendar: FSCalendar!{
        didSet {
            self.vwcalendar.dataSource = self
            self.vwcalendar.delegate = self
        }
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var rescheduleBtn: UIButton!
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
    @IBOutlet weak var customQstnVw: UIView!
    @IBOutlet weak var customQstnBtn: UIButton!
    @IBOutlet weak var contactUsVw: UIView!
    @IBOutlet weak var contactUsLbl: UILabel!
    
    @IBOutlet weak var cancelTagView: UIView!
    //MARK: - Properties
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
    var dateToDeleselect = Date()
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
    var screenFrom = ""
    var timer : Timer?
    var isFromSelection = false
    var offeredIndex = -1
    var bookingId = ""
    var arrPayments = [GetAllPaymentDetailsData]()
    var selectedTimeIndex = 0
    
    var sessionTypeArr = [String]()
    var sessionTypePriceArr = [String]()
    var sessionTypeIDArr = [String]()
    var sessionPriArr = [String]()
    var selectedSession = ""
    var selectedSessionID = ""
    var isFromReschedule = false
    var isFromRescheduleNo = false
    var isFromFollowup = false
    
    var tempSessionTypeArr = [String]()
    var tempSessionIDTypeArr = [String]()
    var tempSessionTypePriceArr = [String]()
    var tempselectedSession = ""
    
    var allSessionTypeArr = [String]()
    var allSessionIDTypeArr = [String]()
    var allSessionTypePriceArr = [String]()
    var allSessionTypePriceTypeArr = [String]()
    var descSessionTypeArr = [String]()
    
    var isLoop = false
    var isPriceLoop = false
    var updatedprice = ""
    var tapReschudleBtn = false
    var rescheduleCountStr = ""
    var getChargeId = ""
    
    var reloadTimeBoolValue = false
    var sessionTimeMinuteStr = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.isHidden = false
        cancelTagView.isHidden = true
        isLoop = false
        isPriceLoop = false
        updatedprice = ""
        tempSessionTypeArr.removeAll()
        tempSessionTypePriceArr.removeAll()
        tempSessionIDTypeArr.removeAll()
        self.mainScrollview.delegate = self
        vwcalendar.appearance.todayColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
        vwcalendar.appearance.todaySelectionColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
        self.selectedDate = formatter.string(from: self.today)
        offeredCollView.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.ident)
        serviceTimeCollectionVw.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.ident)
        if controllerId == 1{
        btnToPrev.isHidden = true
        btnToCurrent.isHidden = true
        btnToNext.isHidden = true
            self.vwmap.isHidden = false
            self.vwcalendar.isHidden = true
            self.vwCollection.isHidden = true
            self.vwColectionHeightConstarint.constant = 0
            self.vwMapHeightConstraint.constant = 256
            self.vwCalendarHeightConstraint.constant = 300
            self.lblDayWithDate.isHidden = true
            self.lblNoTime.isHidden = true
            
            self.btnBooknow.isHidden = true
            self.priceLabel.isHidden = true
            self.cancelBtn.isHidden = false
            self.contactUsVw.isHidden = false
            self.completedBtn.isHidden = true
            
            // added by ashitesh as per client requirement
            self.cancelBtn.backgroundColor = .clear
            self.cancelBtn.layer.borderColor = UIColor.black.cgColor
            self.cancelBtn.layer.borderWidth = 1
            self.cancelBtn.setTitle("Cancel", for: .normal)
            self.cancelBtn.setTitleColor(.black, for: .normal)
            self.rescheduleBtn.isHidden = false
            
        } else if controllerId == 2 {
            btnToPrev.isHidden = false
            btnToCurrent.isHidden = false
            btnToNext.isHidden = false
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
            self.cancelBtn.isHidden = true
            self.contactUsVw.isHidden = true
            self.completedBtn.isHidden = true
        }else if controllerId == 3 {
            btnToPrev.isHidden = true
            btnToCurrent.isHidden = true
            btnToNext.isHidden = true
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
            self.cancelBtn.isHidden = true
            self.contactUsVw.isHidden = true
            self.completedBtn.isHidden = true
        }else {
            btnToPrev.isHidden = false
            btnToCurrent.isHidden = false
            btnToNext.isHidden = false
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
            self.rescheduleBtn.isHidden = true // ashtesh ashi2
            self.contactUsVw.isHidden = true
            self.completedBtn.isHidden = true
            self.priceLabel.isHidden = false
        }
//        loadApi(top_search: "")
//        vm.delegate = self
//        handlingHeaderInFSCalendar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setVSViewShadow(radius: 10, color: .black, view: self.vwcontainTktCount, opacity: 0.12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadApi(top_search: "")
        vm.delegate = self
        handlingHeaderInFSCalendar()
        
        self.tapReschudleBtn = false
        if self.isFromReschedule == true && isFromRescheduleNo == false {
            self.rescheduleBtn.isHidden = false
            self.cancelBtn.isHidden = true
            self.btnBooknow.isHidden = true
        }else if self.isFromReschedule == false && isFromRescheduleNo == true {
            self.rescheduleBtn.isHidden = false
            self.cancelBtn.isHidden = false
            self.cancelBtn.backgroundColor = .clear
            self.cancelBtn.layer.borderColor = UIColor.black.cgColor
            self.cancelBtn.setTitle("Cancel", for: .normal)
            self.cancelBtn.setTitleColor(.black, for: .normal)
            self.cancelBtn.layer.borderWidth = 1
            self.btnBooknow.isHidden = true
        }
//        else{
//            self.rescheduleBtn.isHidden = true // yet commented ashitesh
//        }
        if self.isFromFollowup == true{
            self.customQstnVw.isHidden = false
        }else {
            self.customQstnVw.isHidden = true //ashi3
        }
        self.setAttributedText()
        self.contactUsLbl.text = R.string.localizable.contactUs()
    }
    
    //MARK: - METHOD TO SET MAP
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
    //MARK: - func Attributed Text
    func setAttributedText(){
        // Create attributed string with underline attribute
                let attributes: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.black // You can customize the color here
                ]
                let attributedString = NSAttributedString(string: R.string.localizable.customQuestion(), attributes: attributes)
                // Apply attributed text to the button
                customQstnBtn.setAttributedTitle(attributedString, for: .normal)
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func btnSubmit(_ sender: UIButton) {
        if id == -1 && tapReschudleBtn == false{
            showAlert(strTitle: R.string.localizable.pleaseSelecttime())
        }else if (tapReschudleBtn == true){
            self.rescheduleBooking()
            self.tapReschudleBtn = false
        }
        else {
            self.backBtn.isHidden = true
            self.vwbookTickets.animShow()
            self.vwToGetBlurEffect.addBlurEffect()
            self.btnToRemove.isHidden = false
        }
    }
    
    @IBAction func cancelBtnTap(_ sender: UIButton) {

                let vc = PrivacyPolicyVC.instance()
                vc.type = R.string.localizable.cancelPolicy()
                vc.isFromReschedule = true
                vc.url = cancelPolicy
                vc.getChargeId = getChargeId
                vc.isComingCancelBooking = true
                vc.timeStr = self.vm.model?.booking_date ?? ""
                            
                            vc.sessionId = self.sessionId
                            vc.bookingId = self.bookingId
                            vc.payment_id = self.vm.model?.payment_id ?? ""
        vc.ammountSTr = self.vm.model?.paid_amount ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func chatButtonAction(_ sender: Any) {
        let vc = ChatBoxView.instance()
        vc.otherUser = (self.vm.model?.created_by ?? "").lowercased()
        vc.reciverId = self.vm.model?.created_id ?? ""
        vc.image = self.vm.model?.chat_user_image ?? ""
        vc.name = self.vm.model?.vendorName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func rescheduleBtnTap(_ sender: UIButton) {
        //handlingHeaderInFSCalendar()
       // self.vwcalendar.reloadData()
        self.vwmap.isHidden = false
        btnToPrev.isHidden = false
        btnToCurrent.isHidden = false
        btnToNext.isHidden = false
        self.vwColectionHeightConstarint.constant = 70
        self.vwMapHeightConstraint.constant = 256
        self.vwCalendarHeightConstraint.constant = 300
        self.lblDayWithDate.isHidden = false
        self.lblNoTime.isHidden = true
        self.vwcalendar.isHidden = false
        self.vwCollection.isHidden = false
        
        self.priceLabel.isHidden = false
        //self.vwcalendar.reloadData()
        //handlingHeaderInFSCalendar()
        
        if id == -1 {
            self.tapReschudleBtn = true
            showAlert(strTitle: R.string.localizable.pleaseSelecttime())
        }else{
            self.rescheduleBooking()
            self.tapReschudleBtn = false
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
        }
    }
    
    @IBAction func customQstnBtnAction(_ sender: Any) {
//        let vc = ContactUsViewVC.instance()
//        vc.session_id = self.sessionId
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.navigationController?.present(vc, animated: true)
        
        let popup = ContactUsView.initWith(frame: UIScreen.main.bounds)
        self.view.addSubview(popup ?? UIView())
        popup?.session_id = self.sessionId
        popup?.contactusCallBack = { [weak self] in
            popup?.removeFromSuperview()
        }
    }
    
    @IBAction func btnIncreaseTicketTap(_ sender: UIButton) {
        var count = (Int(lblTicketCount.text ?? "01") ?? 0)
        self.btndecrease.isUserInteractionEnabled = true
        if count == Int(self.vm.availableTickets?.ticket_avilable ?? "") {
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
            self.backBtn.isHidden = false
        }
    }
}

//MARK: - FSCALENDAR DELEGATE
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
        setHeaderMonth(date: calendar.currentPage)
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
        dateToDeleselect = date
        self.selectedDate = "\(self.formatter.string(from: date))"
        self.lblDayWithDate.text = stringconvertIntoHour(inputDate:  self.selectedDate)
        guard let alldate = self.vm.model?.all_date else {return}
        for val in alldate {
            if selectedDate == val.schedule_date{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if val.is_avilable == "1" {
                        self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: true, session_type_id: self.selectedSessionID, session_type: self.selectedSession)
                       // self.scrollViewBotmconstarint.constant = 97
                    }
                }
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                   // self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                    self.priceLabel.isHidden = true
                }, completion: nil)
            }
        }
        
        self.vwCollection.reloadData()
        print(self.timeArr)
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

//MARK: - DATE EXTENSION
extension Date {
    func toLocalTime()->Date
    {
        let tz:NSTimeZone = NSTimeZone.default as NSTimeZone
        let seconds:TimeInterval = TimeInterval(tz.secondsFromGMT(for: self as Date))
        return Date(timeInterval: seconds, since: self as Date)
    }
    
}

//MARK: - COLLECTION VIEW DELEGATES AND DATASOURCE
extension SessionDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==colectnVwSessionImage{
            return self.vm.model?.images?.count ?? 0
        }else if collectionView == self.offeredCollView{
            return self.sessionTypeArr.count
        }
        else if(collectionView == serviceTimeCollectionVw){

            sessionPriArr.removeAll()
//            if((self.vm.model?.session_booking_session_type ?? "") != ""){
//                self.sessionPriArr.append(self.vm.model?.booked_price_type ?? "")
//                print("sessionPriArr",self.sessionPriArr)
//            }else{
                for i in 0..<(self.vm.model?.session_type?.count ?? 0){
                    if self.vm.model?.session_type?[i].session_type == self.selectedSession{
                        self.sessionPriArr.append(self.vm.model?.session_type?[i].price_type ?? "")
                    }
                }
                print("sessionPriArr",self.sessionPriArr)
            if(sessionTimeMinuteStr == ""){
                self.sessionTimeMinuteStr = self.vm.model?.session_type?[0].price_type ?? ""
            }
                return self.sessionPriArr.count
            
            
//            return self.vm.model?.session_type?.count ?? 0
        }else{
            print("timeCount ",self.timeArr.count)
            return self.timeArr.count
        }
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
                //cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
                cell.vwContainCatgry.backgroundColor = UIColor.lightGray
                cell.vwContainCatgry.layer.cornerRadius = 10
                
            } else {
                if id == indexPath.row {
                    cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 0.7411764706, alpha: 1)
                } else {
                    cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
                }
                cell.vwContainCatgry.layer.cornerRadius = 10
            }
            if self.timeArr[indexPath.row].is_available == "0" {
                cell.vwContainCatgry.backgroundColor = UIColor.lightGray
            }
            cell.setData(data: self.timeArr[indexPath.row])
            return cell
        }
        else if collectionView == self.offeredCollView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
            // cell.searchCategorylbl.text = self.vm.model?.session_type?[indexPath.row].session_type
            cell.searchCategorylbl.text = self.sessionTypeArr[indexPath.row]
            if offeredIndex != -1{
                //                print("Price is",self.vm.model?.session_type?[offeredIndex].price ?? "")
                //print("Price is",self.sessionTypePriceArr[offeredIndex])
                
                //                let myDouble  = Double(self.vm.model?.session_type?[offeredIndex].price ?? "") ?? 0.0
                //                let strPrice = self.vm.model?.session_type?[offeredIndex].price ?? ""
                if(isPriceLoop == false && isLoop == false){
                    let myDouble  = Double(self.sessionTypePriceArr[offeredIndex]) ?? 0.0
                    let strPrice = self.sessionTypePriceArr[offeredIndex]
                    self.updatedprice = strPrice
                    
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .currency
                    currencyFormatter.locale =  Locale(identifier: "en_US")
                    let num = Int(strPrice);
                    if num != nil {
                        currencyFormatter.minimumFractionDigits = 0
                        print("Valid Integer")
                    }
                    else {
                        currencyFormatter.minimumFractionDigits = 2
                        print("Not Valid Integer")
                    }
                    
                    let  priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
                    let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                    if let currency = self.vm.model?.currency {
                        
                        self.selectedSession = self.vm.model?.session_type?[0].session_type ?? ""
                        self.priceLabel.text = replaced + " " +  currency
                        self.lblsessiondetail.text = self.vm.model?.session_type?[0].descriptionen ?? ""
                        self.selectedSessionID = self.vm.model?.session_type?[0].session_type_id ?? ""
                        if(self.reloadTimeBoolValue == false){
                            
                            self.reloadTime()
                        }
                    }
                }
            }
            if(isLoop == true){
                isPriceLoop = true
            for i in 0..<(self.allSessionTypeArr.count){
                var indexPosi = 0
                if((self.allSessionTypeArr[i] == selectedSession) && selectedSession != ""){
                    if(isLoop == true){
                       // if((selectedTimeIndex + 1) == sessionPriArr.count ){
                        if(selectedTimeIndex < sessionPriArr.count ){
                            
                        }else{
                            selectedTimeIndex = 0
                            
                        }
                       // for j in 0..<sessionPriArr.count{
                           // if(j == selectedTimeIndex){
                                if(sessionPriArr[selectedTimeIndex] == "sixty" ){
                                    self.sessionTimeMinuteStr = "sixty"
                                    indexPosi = i + selectedTimeIndex
                                            if(isLoop == true){
                                                self.lblsessiondetail.text = self.descSessionTypeArr[indexPosi]
                                            let myDouble  = Double(self.allSessionTypePriceArr[indexPosi]) ?? 0.0
                                            let strPrice = self.allSessionTypePriceArr[indexPosi]
                                                self.updatedprice = strPrice
                                            let currencyFormatter = NumberFormatter()
                                            currencyFormatter.usesGroupingSeparator = true
                                            currencyFormatter.numberStyle = .currency
                                            currencyFormatter.locale =  Locale(identifier: "en_US")
                                            let num = Int(strPrice);
                                            if num != nil {
                                                currencyFormatter.minimumFractionDigits = 0
                                                print("Valid Integer")
                                            }
                                            else {
                                                currencyFormatter.minimumFractionDigits = 2
                                                print("Not Valid Integer")
                                            }
                                            
                                            let  priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
                                            let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                                            if let currency = self.vm.model?.currency {
                                                self.priceLabel.text = replaced + " " +  currency
                                                self.selectedSessionID = self.allSessionIDTypeArr[indexPosi]
                                                self.reloadTimeBoolValue = false
                                               // if(self.isFromSelection == true){
                                                self.vwcalendar.deselect(self.dateToDeleselect)
                                                self.id = -1
                                                self.selectedDate = formatter.string(from: self.today)
                                                self.lblDayWithDate.text = stringconvertIntoHour(inputDate:  self.selectedDate)
                                                    self.reloadTime()
                                               // }
                                                self.isLoop = false
                                                indexPosi = 0
                                            }
        //                                }
        //                                }
                                    }
                                }else if (sessionPriArr[selectedTimeIndex] == "ninety"){
                                   // for i in 0..<(self.allSessionTypePriceTypeArr.count){
                                        //if(self.allSessionTypePriceTypeArr[i] == sessionPriArr[selectedTimeIndex]){
                                            //
                                    self.sessionTimeMinuteStr = "ninety"
                                    indexPosi = i + selectedTimeIndex
                                            if(isLoop == true){
                                                self.lblsessiondetail.text = self.descSessionTypeArr[indexPosi]
                                                let myDouble  = Double(self.allSessionTypePriceArr[indexPosi]) ?? 0.0
                                                let strPrice = self.allSessionTypePriceArr[indexPosi]
                                                self.updatedprice = strPrice
                                                let currencyFormatter = NumberFormatter()
                                                currencyFormatter.usesGroupingSeparator = true
                                                currencyFormatter.numberStyle = .currency
                                                currencyFormatter.locale =  Locale(identifier: "en_US")
                                                let num = Int(strPrice);
                                                if num != nil {
                                                    currencyFormatter.minimumFractionDigits = 0
                                                    print("Valid Integer")
                                                }
                                                else {
                                                    currencyFormatter.minimumFractionDigits = 2
                                                    print("Not Valid Integer")
                                                }
                                                
                                                let  priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
                                                let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                                                if let currency = self.vm.model?.currency {
                                                    self.priceLabel.text = replaced + " " +  currency
                                                    self.selectedSessionID = self.allSessionIDTypeArr[indexPosi]
                                                    self.reloadTimeBoolValue = false
                                                    //if(self.isFromSelection == true){
                                                    self.vwcalendar.deselect(self.dateToDeleselect)
                                                    self.id = -1
                                                    self.selectedDate = formatter.string(from: self.today)
                                                    self.lblDayWithDate.text = stringconvertIntoHour(inputDate:  self.selectedDate)
                                                        self.reloadTime()
                                                    //}
                                                    self.isLoop = false
                                                    indexPosi = 0
                                                }
                                            }
                                        //}
                                    //}
                                }else{
        //                            for i in 0..<(self.allSessionTypePriceTypeArr.count){
        //                                if(self.allSessionTypePriceTypeArr[i] == sessionPriArr[selectedTimeIndex]){
        //                                    //
                                    self.sessionTimeMinuteStr = "one_twenty"
                                    indexPosi = i + selectedTimeIndex
                                            if(isLoop == true){
                                                self.lblsessiondetail.text = self.descSessionTypeArr[indexPosi]
                                                let myDouble  = Double(self.allSessionTypePriceArr[indexPosi]) ?? 0.0
                                                let strPrice = self.allSessionTypePriceArr[indexPosi]
                                                self.updatedprice = strPrice
                                                let currencyFormatter = NumberFormatter()
                                                currencyFormatter.usesGroupingSeparator = true
                                                currencyFormatter.numberStyle = .currency
                                                currencyFormatter.locale =  Locale(identifier: "en_US")
                                                let num = Int(strPrice);
                                                if num != nil {
                                                    currencyFormatter.minimumFractionDigits = 0
                                                    print("Valid Integer")
                                                }
                                                else {
                                                    currencyFormatter.minimumFractionDigits = 2
                                                    print("Not Valid Integer")
                                                }
                                                
                                                let  priceString = currencyFormatter.string(from: NSNumber(value: myDouble ))!
                                                let replaced = priceString.replacingOccurrences(of: "$", with: "") // "aaaaaaaa"
                                                if let currency = self.vm.model?.currency {
                                                    self.priceLabel.text = replaced + " " +  currency
                                                    self.selectedSessionID = self.allSessionIDTypeArr[indexPosi]
                                                    self.reloadTimeBoolValue = false
                                                   // if(self.isFromSelection == true){
                                                    self.vwcalendar.deselect(self.dateToDeleselect)
                                                    self.id = -1
                                                    self.selectedDate = formatter.string(from: self.today)
                                                    self.lblDayWithDate.text = stringconvertIntoHour(inputDate:  self.selectedDate)
                                                        self.reloadTime()
                                                   // }
                                                    self.isLoop = false
                                                    indexPosi = 0
                                                }
                                            }
        //                                }
        //                            }
                                }
//                            }else{
//                                print("New1")
//                            }
                        //}
                    }
                }
            }
        }
            
            if offeredIndex == indexPath.row {
                cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 0.7411764706, alpha: 1)
            } else {
                cell.vwContainCatgry.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.4039215686, blue: 0.8509803922, alpha: 1)
            }
            cell.vwContainCatgry.layer.cornerRadius = 10
            
            return cell
        }
        else if(collectionView == serviceTimeCollectionVw){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.ident, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
            
//            if(self.vm.model?.session_type?[indexPath.row].price_type == "sixty"){
//                cell.searchCategorylbl.text = "60 mins"
//            }else if (self.vm.model?.session_type?[indexPath.row].price_type == "ninety"){
//                cell.searchCategorylbl.text = "90 mins"
//            }else{
//
//                cell.searchCategorylbl.text = "120 mins"
//            }
            if(sessionPriArr[indexPath.row] == "sixty"){
                cell.searchCategorylbl.text = "60 mins"
            }else if (sessionPriArr[indexPath.row] == "ninety"){
                cell.searchCategorylbl.text = "90 mins"
            }else{
                cell.searchCategorylbl.text = "120 mins"
            }
            
            if(selectedTimeIndex == indexPath.item){
                cell.searchCategorylbl.textColor = UIColor.white
                cell.vwContainCatgry.backgroundColor =  UIColor(red: 5/255, green: 217/255, blue: 189/255, alpha: 1)
            }else{
                cell.searchCategorylbl.textColor = UIColor.black
                cell.vwContainCatgry.backgroundColor = UIColor.white
            }
            cell.vwContainCatgry.layer.borderWidth = 1
            cell.vwContainCatgry.layer.borderColor = UIColor(red: 5/255, green: 217/255, blue: 189/255, alpha: 1).cgColor
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // self.isFromSelection = false
        if collectionView == self.vwCollection{
            if self.timeArr[indexPath.row].is_available == "0" {
                self.id = -1
            }else{
                if self.id == indexPath.row{
                } else {
                    self.id = indexPath.row
                    //                if(self.tapReschudleBtn == true){
                    //                    self.rescheduleBooking()
                    //                }else{
                    guard let userid = SaveToDefaults().getUserId() else { return}
                    self.vm.getTicketDataApi(user_id: userid, session_id: sessionId, schedule_time_id: self.timeArr[id].schedule_time_id ?? "")
                    //              }
                }
            }
            self.vwCollection.reloadData()
        }else if collectionView == self.offeredCollView{
            self.offeredIndex = indexPath.row
            self.selectedSession = sessionTypeArr[indexPath.row]
//            self.selectedSessionID = self.sessionTypeIDArr[indexPath.row]
//            print("selectedSessionID",self.selectedSessionID) // ashiteshhh
            isLoop = true
            collectionView.reloadData()
            serviceTimeCollectionVw.reloadData()
        }
        else if(collectionView == serviceTimeCollectionVw){
            self.selectedTimeIndex = indexPath.row
            isLoop = true
            offeredCollView.reloadData()
            serviceTimeCollectionVw.reloadData()
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
            //let text = self.vm.model?.session_type?[indexPath.row].session_type
            let text = sessionTypeArr[indexPath.row]
            
            let label = UILabel(frame: CGRect.zero)
            label.text = text
            label.sizeToFit()
            return CGSize(width: label.frame.size.width+22, height: 55)
        }
        else if(collectionView == serviceTimeCollectionVw){
            let text = self.vm.model?.session_type?[indexPath.row].price_type
            let label = UILabel(frame: CGRect.zero)
            label.text = text
            label.sizeToFit()
//            return CGSize(width: label.frame.size.width+22, height: 55)
            return CGSize(width: 120, height: 55)
        }
        else {
            return CGSize(width: SCREEN_WIDTH, height: self.colectnVwSessionImage.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView==self.colectnVwSessionImage {
            self.pageCtrl.numberOfPages = self.vm.model?.images?.count ?? 0
            self.pageCtrl.currentPage = indexPath.row
        }
    }
}

//MARK: - CUSTOM DELEGATE
extension SessionDetailVC: GetResponse {
    func refundAPiResponse(){
       // self.navigationController?.popViewController(animated: true)
        let vc = PrivacyPolicyVC.instance()
                vc.type = "Cancellation Policy"
                vc.url = "http://dharma.services/cancel_policy.html"
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sessionTimeDetail(){
        self.timeArr.removeAll()
        self.timeArr = self.vm.timeArr?.result ?? []
        
        for i in 0..<(self.vm.timeArr?.result?.count ?? 0){
            if((self.vm.timeArr?.result?[i].booked_price_type ?? "") != ""){
                self.sessionTypeArr.removeAll()
                self.sessionTypePriceArr.removeAll()
                self.sessionTypeIDArr.removeAll()
    
               // self.sessionTypeArr.append(self.vm.timeArr?.result?[i].session_booking_session_type ?? "")
                //self.sessionTypePriceArr.append(self.vm.model?.session_type?[i].price ?? "")
                //self.sessionTypeIDArr.append(self.vm.model?.session_type?[i].session_type_id ?? "")
                
                //self.selectedSession = self.vm.model?.session_booking_session_type ?? ""
                /*self.sessionTypePriceArr.append(self.vm.model?.booked_price_type ?? "")*/ // now wrong type selection
                self.sessionTypePriceArr.append(self.vm.model?.session_booking_amount ?? "")
                self.sessionTypeArr.append(self.vm.model?.session_booking_session_type ?? "")
                self.sessionTypeIDArr.append(self.vm.model?.session_booking_type_id ?? "")
                
            }else{
                self.sessionTypeArr.removeAll()
                self.sessionTypePriceArr.removeAll()
                self.sessionTypeIDArr.removeAll()
                
                self.sessionTypeArr = self.tempSessionTypeArr
                self.sessionTypePriceArr  = self.tempSessionTypePriceArr
//                self.selectedSession = self.tempselectedSession
                if(selectedSession == ""){
                    self.selectedSession = self.vm.model?.session_type?[0].session_type ?? ""
                }
                self.sessionTypeIDArr = self.tempSessionIDTypeArr
            }
        }
        if self.controllerId != 1{
            if self.timeArr.count == 0 {
                self.btnBooknow.isHidden = true
                self.priceLabel.isHidden = true
                //self.scrollViewBotmconstarint.constant = 0
            } else {
                if self.isFromReschedule == false && isFromRescheduleNo == true {
                    self.rescheduleBtn.isHidden = false
                    self.cancelBtn.isHidden = false
                    self.cancelBtn.backgroundColor = .clear
                    self.cancelBtn.layer.borderColor = UIColor.black.cgColor
                    self.cancelBtn.setTitle("Cancel", for: .normal)
                    self.cancelBtn.setTitleColor(.black, for: .normal)
                    self.cancelBtn.layer.borderWidth = 1
                    self.btnBooknow.isHidden = true
                }else{
                    self.btnBooknow.isHidden = false
                    self.priceLabel.isHidden = false
                    self.cancelBtn.isHidden = true
                    self.rescheduleBtn.isHidden = true // here one
                }
                //self.scrollViewBotmconstarint.constant = 97
                if  self.isFromSelection{
                    let bottomOffset = CGPoint(x: 0, y: self.mainScrollview.contentSize.height - mainScrollview.bounds.height + mainScrollview.contentInset.bottom)
                    mainScrollview.setContentOffset(bottomOffset, animated: true)
                }
            }
        }
        self.vwCollection.reloadData()
        self.offeredCollView.reloadData()
        self.serviceTimeCollectionVw.reloadData()
    }
    
    func reloadTime() {
        guard let alldate = self.vm.model?.all_date else {return}
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        for val in alldate {
            //if self.formatter.string(from: self.today) == val.schedule_date && val.is_avilable ?? "0" == "1"{
            if selectedDate == val.schedule_date{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if((self.selectedSessionID != "") && (self.reloadTimeBoolValue == false)){
                        self.reloadTimeBoolValue = true
                        self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: false, session_type_id: self.selectedSessionID, session_type: self.selectedSession)
                        break
                    }
                    //self.scrollViewBotmconstarint.constant = 97
                }
            }else{
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                   // self.scrollViewBotmconstarint.constant = 0
                    self.btnBooknow.isHidden = true
                    self.priceLabel.isHidden = true
                }, completion: nil)
            }
//                break
//            } 
//            else {
//                self.timeArr.removeAll()
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
//                   // self.scrollViewBotmconstarint.constant = 0
//                    //self.btnBooknow.isHidden = true
//                }, completion: nil)
//                
//            }
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
        vc.getSessionTimeMinuteStr = sessionTimeMinuteStr
        vc.selectedSessionSTr = selectedSession
        //vc.getPriceFromPreviousPage =
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - METHOD TO RELOAD DATA
    func reloadData() {
        DispatchQueue.main.async {
            self.SetMap()
        }
        self.timeArr = self.vm.timeArr?.result ?? Array()
        if self.controllerId != 1{
            if self.timeArr.count == 0 {
                self.btnBooknow.isHidden = true
                self.priceLabel.isHidden = true
                //self.scrollViewBotmconstarint.constant = 0
            } else {
                self.btnBooknow.isHidden = false
                self.priceLabel.isHidden = false
                self.cancelBtn.isHidden = true
                self.rescheduleBtn.isHidden = true
                //self.scrollViewBotmconstarint.constant = 97
            }
        }
        self.sessionTypeArr.removeAll()
        self.sessionTypePriceArr.removeAll()
        self.tempSessionTypeArr.removeAll()
        self.tempSessionIDTypeArr.removeAll()
        self.tempSessionTypePriceArr.removeAll()
        self.allSessionTypeArr.removeAll()
        self.allSessionIDTypeArr.removeAll()
        self.allSessionTypePriceArr.removeAll()
        self.descSessionTypeArr.removeAll()
        self.allSessionTypePriceTypeArr.removeAll()
        for i in 0..<(self.vm.model?.session_type?.count ?? 0){
            self.allSessionTypeArr.append(self.vm.model?.session_type?[i].session_type ?? "")
            self.allSessionIDTypeArr.append(self.vm.model?.session_type?[i].session_type_id ?? "")
            self.allSessionTypePriceArr.append(self.vm.model?.session_type?[i].price ?? "")
            self.descSessionTypeArr.append(self.vm.model?.session_type?[i].descriptionen ?? "")
            self.allSessionTypePriceTypeArr.append(self.vm.model?.session_type?[i].price_type ?? "")
            if(tempSessionTypeArr.contains(self.vm.model?.session_type?[i].session_type ?? "")){
            }else{
                self.tempSessionTypeArr.append(self.vm.model?.session_type?[i].session_type ?? "")
                self.tempselectedSession = self.vm.model?.session_type?[i].session_type ?? ""
                self.tempSessionTypePriceArr.append(self.vm.model?.session_type?[i].price ?? "")
                self.tempSessionIDTypeArr.append(self.vm.model?.session_type?[i].session_type_id ?? "")
            }
        }
        
        if((self.vm.model?.booked_price_type ?? "") != "" && self.controllerId == 1){

           // for i in 0..<(self.vm.model?.session_type?.count ?? 0){
//                if(sessionTypeArr.contains(self.vm.model?.session_type?[i].session_type ?? "")){
//                }else{
//                    self.selectedSession = self.vm.model?.session_type?[i].session_type ?? ""
//                    self.sessionTypePriceArr.append(self.vm.model?.session_type?[i].price ?? "")
//                    self.sessionTypeArr.append(self.vm.model?.session_booking_session_type ?? "")
//                    self.sessionTypeIDArr.append(self.vm.model?.session_type?[i].session_type_id ?? "")
            //    }
           // }
            /* for booked status detail */
            self.selectedSession = self.vm.model?.session_booking_session_type ?? ""
            //self.sessionTypePriceArr.append(self.vm.model?.booked_price_type ?? "")
            self.sessionTypePriceArr.append(self.vm.model?.session_booking_amount ?? "")
            self.sessionTypeArr.append(self.vm.model?.session_booking_session_type ?? "") // here 1 count
            self.sessionTypeIDArr.append(self.vm.model?.session_booking_type_id ?? "")
            
        }else{
            for i in 0..<(self.vm.model?.session_type?.count ?? 0){
                if(sessionTypeArr.contains(self.vm.model?.session_type?[i].session_type ?? "")){
                }else{
                    self.sessionTypeArr.append(self.vm.model?.session_type?[i].session_type ?? "")
                    self.selectedSession = self.vm.model?.session_type?[0].session_type ?? ""
                    self.sessionTypePriceArr.append(self.vm.model?.session_type?[i].price ?? "") // here comes
                    self.sessionTypeIDArr.append(self.vm.model?.session_type?[i].session_type_id ?? "")
                }
            } // ashiteshhh
        }
        
        guard let data = self.vm.model, let lat1 = self.vm.model?.latitude, let lang1 = self.vm.model?.longitude else {return}
        if data.booking_date ?? "" == ""{
            self.bookingDateLbl.text = ""
        }else{
            let getBookingToTimeStr = data.booking_to_time ?? ""
            var dateToTimeStr = ""
            
            if(getBookingToTimeStr != ""){
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from:getBookingToTimeStr)!
                
                // let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateToTimeStr = dateFormatter.string(from: date)
            }
            
            self.bookingDateLbl.text = "\(R.string.localizable.bookingdate()) \(changeDateFormatForReminder(date: data.booking_date ?? "", fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd MMM yyyy hh:mm a", currentTimeZone: data.currenttimezone ?? ""))" + "-" + dateToTimeStr
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
        
        self.lblSessionPlaceName.text = data.name_of_listing
        self.lblsessiondetail.text = data.description
        if self.vm.model?.session_type?.count ?? 0 == 0{
            self.offerdView.isHidden = true
            self.offeredHeightCons.constant = 0
            self.offeredIndex = -1
        }else{
            if self.offeredIndex == -1{
                self.offeredIndex = 0
            }
            self.offerdView.isHidden = false
//            self.offeredHeightCons.constant = 116
            
            self.offeredHeightCons.constant = 198
        }
        self.vwCollection.reloadData()
        if(data.session_booking_status == "2" ||  data.session_booking_status == "3"){
            self.cancelBtn.isEnabled = false
            self.cancelBtn.setTitle("Cancelled", for: .normal)
            self.cancelBtn.backgroundColor = UIColor(red: 96/255, green: 103/255, blue: 217/255, alpha: 1)
            self.cancelBtn.setTitleColor(.white, for: .normal)
            self.cancelBtn.layer.borderWidth = 0
            self.cancelBtn.layer.borderColor = UIColor.clear.cgColor
            self.rescheduleBtn.isHidden = true
            self.cancelTagView.isHidden = true
//            if(self.screenFrom == "EventVC"){
//                self.cancelTagView.isHidden = false
//            }else{
//                self.cancelTagView.isHidden = true
//            }
        }else {
            self.cancelTagView.isHidden = true
            self.cancelBtn.isEnabled = true
            self.cancelBtn.setTitle("Cancel", for: .normal)
        }
        self.vwcalendar.reloadData()
        self.colectnVwSessionImage.reloadData()
        self.offeredCollView.reloadData()
        self.serviceTimeCollectionVw.reloadData()
        self.timer?.invalidate()
        setuptimer()
        guard let alldate = self.vm.model?.all_date else {return}
        self.formatter.dateFormat = "yyyy-MM-dd"
        for val in alldate {
            if self.formatter.string(from: self.today) == val.schedule_date && val.is_avilable ?? "0" == "1"{
                if let userid = SaveToDefaults().getUserId(), let scheduleId =  val.schedule_id {
                    if self.controllerId == 0 || self.controllerId == 2{
                        self.vm.timingArrayOfSpecificDateApi(user_id: userid, schedule_id: scheduleId, isloader: false, session_type_id: self.selectedSessionID, session_type: self.selectedSession)
                       // self.scrollViewBotmconstarint.constant = 97
                    }
                }
                break
            } else {
                self.timeArr.removeAll()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                   // self.scrollViewBotmconstarint.constant = 0
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
                        self.getChargeId = dict.charge_id ?? ""
                    }
                }
            }
        }
        
    }}

//MARK: - VIEW CONTROLLER EXTENSION
extension SessionDetailVC {
    //MARK: - METHOD TO AUTOMATIC SCROLL
    private func setuptimer() {
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
        //        self.backBtn.isHidden = false
            }else{
                if scrollView.contentOffset.y > 55 {
        //            self.backBtn.isHidden = true
                }else{
         //           self.backBtn.isHidden = false
                }
            }
        }
    }
    
    //MARK: - API INETEGRATION
    private func loadApi(top_search: String) {
        guard let userid = SaveToDefaults().getUserId(), let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  else {return}
        self.vm.sessionDtailApi(user_id: userid, session_id: sessionId, latitude: "\(lat)", longitude: "\(lng)", top_search: top_search,bookingId: self.bookingId)
        
    }
    
    private func bookingApi() {
        guard let userid = SaveToDefaults().getUserId() else {return}
        if let id = self.vm.model?.session_id, let lat = SaveToDefaults().getLatitude(), let lng = SaveToDefaults().getLongtitude()  {
            var amt = ""
            var offeredTypeId = ""
            amt = self.updatedprice
            if self.offeredIndex != -1{
                offeredTypeId = selectedSessionID
                if selectedSessionID == "" {
                    self.selectedSessionID = self.sessionTypeIDArr[0]
                    offeredTypeId = selectedSessionID
                }
               // offeredTypeId = self.vm.model?.session_type?[self.offeredIndex].session_type_id ?? ""
               // amt = self.vm.model?.session_type?[self.offeredIndex].price ?? ""
               
            }else{
                return
            }
            self.vm.checkTicketAvailabilityApi(user_id: userid, session_id: id, latitude: "\(lat)", longitude: "\(lng)", ticket: self.lblTicketCount.text ?? "", booking_date: self.selectedDate, booking_from_time: "\(self.vm.timeArr?.result?[self.id].from_time ?? "0")", booking_to_time: "\(self.vm.timeArr?.result?[self.id].to_time ?? "0")", paid_amount: amt, schedule_time_id: "\(self.vm.timeArr?.result?[self.id].schedule_time_id ?? "0")", offeredTypeId: offeredTypeId)
        }
    }
     
    //MARK: - Reschedule Api
    private func rescheduleBooking(){
        guard let userid = SaveToDefaults().getUserId() else {return}
        self.vm.sessionRescheduleApi(user_id: userid, session_id: sessionId, booking_id: bookingId, booking_date: self.selectedDate, booking_from_time: "\(self.vm.timeArr?.result?[self.id].from_time ?? "0")", booking_to_time: "\(self.vm.timeArr?.result?[self.id].to_time ?? "0")", schedule_time_id: "\(self.vm.timeArr?.result?[self.id].schedule_time_id ?? "0")", rescheduleCount: rescheduleCountStr,session_time_minute : self.sessionTimeMinuteStr,selectedSessionSTr : self.selectedSession)
        self.vm.rescheduleSuccesClosure = {[weak self ] in
//            guard let self else {return}
//            let vc = ThankyouVC.instance()
//            vc.isFromReschedule = true
//            self.navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self?.navigationController?.popViewController(animated: true)
            })
            
        }
        self.vm.rescheduleErrorClosure = {[weak self ] in
            self?.vwCollection.isHidden = true
            
        }
    }
    //MARK: - Customization Of view
    private func customizationOfView(){
        DispatchQueue.main.async {
            setRightShadow(view: self.vwContainfee, color: #colorLiteral(red: 0.4522080421, green: 0.4990295768, blue: 0.8806897998, alpha: 1), opacity: 0.7, width: 5, height: 4)
            setRightShadowWithOffset(view: self.vwsession, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.2, width: 5, height: 5, offsetX: 10, offsetY: 20)
            setRightShadowWithOffset(view: self.langView, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), opacity: 0.2, width: 5, height: 5, offsetX: 10, offsetY: 20)
        }
    }
    
    //MARK: - Function To handle the current year montrh date in FsCalendar
    private func handlingHeaderInFSCalendar() {
        let date = Date()
        setHeaderMonth(date:date)
        customizationOfView()
        self.lblDayWithDate.text = convertIntoHourFormatted(inputDate: self.today)
    }
    
}

//MARK: - DATE EXTENSION
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

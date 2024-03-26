//
//  ChatBoxTVAdapter.swift
//  reachout
//
//  Created by Anuj Techugo on 19/08/21.
//  Copyright © 2021 techugo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MapKit

protocol DelegatePlayVideo : Any{
    func PlayVideoURL(url: String)
    func ImageZoomUrl(url: String)
}

class MyMessageTVCell: UITableViewCell {
    
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var msgLbl: UILabel!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        self.msgLbl.text = model.msg
    }
}

class MyAudioTVCell: UITableViewCell {
    
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var playPauseBtn: UIButton!
    
    private var model: MessageModel!
    var playerItem: AVPlayerItem?
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        
        guard !model.url.isEmpty, let url = URL(string: model.url) else {
            self.playPauseBtn.isEnabled = false
            return
        }
        self.playerItem = AVPlayerItem(url: url)
    }
}

class MyImageTVCell: UITableViewCell {
    @IBOutlet var playButton: UIButton!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var photoIV: UIImageView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        if !model.url.isEmpty, let url = URL(string: model.url) {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
                self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
//            }
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
    }
}
class MyVideoTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        if !model.url.isEmpty, let url = URL(string: model.videoThumbnail ?? "") {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
//            }
            self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
    }
}
class MyImagesTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBOutlet var photoIVs: [UIImageView]!
    @IBOutlet weak var plusNLbl: UILabel!
    
    private var model: MessageModel!
    
    fileprivate func loadAndSetImage(index: Int, _ url: String) {
        if let url = URL(string: url) {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIVs[index].image = img
//            }
            self.photoIVs[index].sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIVs[index].image = UIImage(systemName: "photo.fill")
        }
    }
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        //        for (index,url) in model.url.enumerated() {
        //            guard index <= 3 else {
        //                self.plusNLbl.text = "+\(model.url.count - 4)"
        //                self.plusNLbl.isHidden = false
        //                break
        //            }
        self.plusNLbl.isHidden = true
        loadAndSetImage(index: 0, model.url)
        //        }
    }
}

class PartnerMessageTVCell: UITableViewCell {
    
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet weak var msgLbl: UILabel!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = model.addedOn.localDate(inFormat: .h_mm_a)?.string
        }
        else {
            self.dateTimeLbl.text = date
        }
        self.msgLbl.text = model.msg
    }
}

class PartnerAudioTVCell: UITableViewCell {
    
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet weak var playPauseBtn: UIButton!
    
    private var model: MessageModel!
    var playerItem: AVPlayerItem?
    
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = model.addedOn.localDate(inFormat: .h_mm_a)?.string
        }
        else {
            self.dateTimeLbl.text = date
        }
        //        var audioUrl = model.url
        //        if audioUrl.contains(find: ".3gp"){
        //            audioUrl = audioUrl.replacingOccurrences(of: ".3gp", with: ".m4a")
        //        }
        guard !model.url.isEmpty, let url = URL(string: model.url) else {
            self.playPauseBtn.isEnabled = false
            return
        }
        self.playerItem = AVPlayerItem(url: url)
    }
}

class PartnerImageTVCell: UITableViewCell {
    @IBOutlet var playButton: UIButton!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet weak var photoIV: UIImageView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = model.addedOn.localDate(inFormat: .h_mm_a)?.string
        }
        else {
            self.dateTimeLbl.text = date
        }
        if !model.url.isEmpty, let url = URL(string: model.url) {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
//            }
            self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
    }
}
class PartnerVideoTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = model.addedOn.localDate(inFormat: .h_mm_a)?.string
        }
        else {
            self.dateTimeLbl.text = date
        }
        if !model.url.isEmpty, let url = URL(string: model.videoThumbnail ?? "") {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
//            }
            self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
    }
}

class PartnerImagesTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet var photoIVs: [UIImageView]!
    @IBOutlet weak var plusNLbl: UILabel!
    
    private var model: MessageModel!
    
    fileprivate func loadAndSetImage(index: Int, _ url: String) {
        if let url = URL(string: url) {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIVs[index].image = img
//            }
            self.photoIVs[index].sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIVs[index].image = UIImage(systemName: "photo.fill")
        }
    }
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = model.addedOn.localDate(inFormat: .h_mm_a)?.string
        }
        else {
            self.dateTimeLbl.text = date
        }
        //        for (index,url) in model.url.enumerated() {
        //            guard index <= 3 else {
        //                self.plusNLbl.text = "+\(model.url.count - 4)"
        //                self.plusNLbl.isHidden = false
        //                break
        //            }
        self.plusNLbl.isHidden = true
        // loadAndSetImage(index: index, model.url)
        loadAndSetImage(index: 0, model.url)
        //        }
    }
}



class MyLocationTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        if !model.url.isEmpty, let url = URL(string: model.videoThumbnail ?? "") {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
//            }
            self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
        let center = CLLocationCoordinate2D(latitude: Double(model.lat ?? "0.0") ?? 0.0, longitude: Double(model.long ?? "0.0") ?? 0.0)
               let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

               self.mapView.setRegion(region, animated: true)
    }
}


class PartnerLocationTVCell: UITableViewCell {
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var msgBalloonVw: UIView! {
        didSet {
            self.msgBalloonVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    
    private var model: MessageModel!
    
    func set(_ model: MessageModel) {
        self.model = model
        let date = TUGHelpers.getChatDay(chatDate: TUGHelpers.getDate(DateStr: model.addedOn ) ?? Date())
        if date == "Today"
        {
            self.dateTimeLbl.text = "\(model.addedOn.localDate(inFormat: .h_mm_a)?.string ?? "")"
        }
        else {
            self.dateTimeLbl.text = "\(date)"
        }
        if !model.url.isEmpty, let url = URL(string: model.videoThumbnail ?? "") {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                self.photoIV.image = img
//            }
            self.photoIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            self.photoIV.image = UIImage(systemName: "photo.fill")
        }
    }
}

//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit
import MarqueeLabel

open class FSPagerViewCell: UICollectionViewCell {
    
    /// Returns the label used for the main textual content of the pager view cell.
    @objc
    open var textLabel: MarqueeLabel? {
        if let _ = _textLabel {
            return _textLabel
        }
        let view = UIView(frame: CGRect(x: 0, y: 5, width: self.contentView.frame.size.width, height: 25.0))
            view.isUserInteractionEnabled = false
            view.backgroundColor = .clear
            let textLabel = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 30))
            textLabel.textColor = .white
        textLabel.font = UIFont(name: Fonts.bold.rawValue, size: 16)
            textLabel.textAlignment = .center
            

            self.contentView.addSubview(view)
            view.addSubview(textLabel)
            
            textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)
            
            _textLabel = textLabel
            return textLabel    }
    
    /// Returns the image view of the pager view cell. Default is nil.
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: CGRect.init(x: 25, y: 0, width: 50, height: 50))
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }
    
    fileprivate weak var _textLabel: MarqueeLabel?
    fileprivate weak var _imageView: UIImageView?
    
    var pageViewTag : Int = 1
    
    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)
    
    fileprivate weak var _selectedForegroundView: UIView?
    fileprivate var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        guard let imageView = _imageView else {
            return nil
        }
        let view = UIView(frame: imageView.bounds)
        imageView.addSubview(view)
        _selectedForegroundView = view
        return view
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            if newValue {
                self.selectedForegroundView?.layer.backgroundColor = self.selectionColor.cgColor
            } else if !super.isSelected {
                self.selectedForegroundView?.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
        get {
            return super.isHighlighted
        }
    }
    
    open override var isSelected: Bool {
        set {
            super.isSelected = newValue
            self.selectedForegroundView?.layer.backgroundColor = newValue ? UIColor.gray.cgColor : UIColor.clear.cgColor
        }
        get {
            return super.isSelected
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
//        self.contentView.layer.shadowColor = UIColor.black.cgColor
//        self.contentView.layer.shadowRadius = 5
//        self.contentView.layer.shadowOpacity = 0.75
//        self.contentView.layer.shadowOffset = .zero
    }
    
    deinit {
        if let textLabel = _textLabel {
            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        
        if let imageView = _imageView {
           // imageView.frame = self.contentView.bounds
            imageView.frame = CGRect(x: 12, y: 0, width: 80, height: 80)
            imageView.contentMode = .scaleAspectFit
        }
        
        
        if let textLabel = _textLabel {
            textLabel.superview!.frame = {
                var rect = self.contentView.bounds
                let height = textLabel.font.pointSize*1.5
                rect.size.height = height
                rect.origin.x = 0
                rect.origin.y = (pageViewTag == 1) ? self.contentView.frame.height : self.contentView.frame.height-height
                return rect
            }()
            textLabel.frame = {
                var rect = textLabel.superview!.bounds
                rect = rect.insetBy(dx: 8, dy: 0)
                rect.size.height -= 1
                rect.origin.y += 1
                return rect
            }()
        }
        if let selectedForegroundView = _selectedForegroundView {
            selectedForegroundView.frame = self.contentView.bounds
        }
    }
    
    func bindData(tag:Int) {
        
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == kvoContext {
            if keyPath == "font" {
                self.setNeedsLayout()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setMarquee(label:MarqueeLabel) {
               label.type = .continuous
           label.speed = .duration(4.0)
           label.animationCurve = .linear
           label.fadeLength = 0.0
           label.leadingBuffer = 10.0
           label.trailingBuffer = 30.0
           label.restartLabel()
       }
    
}

//
//  CalendarDateCollectionViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 31/05/22.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarDateCollectionViewCell: FSCalendarCell {

//    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    weak var currentDateSelectionLayer: CAShapeLayer!
    weak var eventDateSelectionLayer: CAShapeLayer!
    
    private var _theme: Theme!
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _theme = ThemeManager.currentTheme()
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = ColorConstant.calendarSelectionBackgroundColor.cgColor
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        let currentDateLayer = CAShapeLayer()
        currentDateLayer.fillColor = ColorConstant.currentDateBackgroundColor.cgColor
        self.contentView.layer.insertSublayer(currentDateLayer, below: self.titleLabel!.layer)
        self.currentDateSelectionLayer = currentDateLayer
        
        let eventDateLayer = CAShapeLayer()
        eventDateLayer.fillColor = UIColor.clear.cgColor
        eventDateLayer.strokeColor = ColorConstant.currentDateBackgroundColor.cgColor
        eventDateLayer.lineWidth = 1
        self.contentView.layer.insertSublayer(eventDateLayer, below: self.titleLabel!.layer)
        self.eventDateSelectionLayer = eventDateLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
//        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.circleImageView.frame = self.contentView.bounds
//        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        
        let height = self.contentView.bounds.height - 6
        let width = self.contentView.bounds.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        self.selectionLayer.frame = rect
        
        let radii = 8
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        } else if selectionType == .leftBorder {
            let leftRect = CGRect(x: 2, y: self.selectionLayer.bounds.origin.y, width: self.selectionLayer.bounds.width, height: self.selectionLayer.bounds.height)
            self.selectionLayer.path = UIBezierPath(roundedRect: leftRect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: radii, height: radii)).cgPath
        } else if selectionType == .rightBorder {
            let rightRect = CGRect(x: 0, y: self.selectionLayer.bounds.origin.y, width: self.selectionLayer.bounds.width - 2, height: self.selectionLayer.bounds.height)
            self.selectionLayer.path = UIBezierPath(roundedRect: rightRect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: radii, height: radii)).cgPath
        } else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: width / 2 - diameter / 2, y: height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
        
        self.currentDateSelectionLayer.frame = rect
        let diameter: CGFloat = min(self.currentDateSelectionLayer.frame.height, self.currentDateSelectionLayer.frame.width) - 4
        self.currentDateSelectionLayer.path = UIBezierPath(ovalIn: CGRect(x: width / 2 - diameter / 2, y: height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        
        self.eventDateSelectionLayer.frame = rect
        self.eventDateSelectionLayer.path = UIBezierPath(ovalIn: CGRect(x: width / 2 - diameter / 2, y: height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        
        self.setStroke(to: self.selectionLayer)
    }
    
    func setStroke(to layer: CAShapeLayer) {
        layer.strokeColor = ColorConstant.selectionBorderColor.cgColor
        layer.lineWidth = 2
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.text = "-"
//            self.titleLabel.textColor = UIColor.red
        }
    }
}

//
//  NotificationsTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 10/11/22.
//

import UIKit

protocol NotificationDelegate {
    func deleteNotification(with indexPath: IndexPath)
}

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNotification: UIImageView!
    @IBOutlet weak var lblNotificationDate: UILabel!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblNotificationDescription: UILabel!
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: NotificationDelegate?
    var indexPath: IndexPath!
    
    private var _theme: Theme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        _theme = ThemeManager.currentTheme()
        
        self.lblNotificationDate.font = _theme.muliFont(size: 14, style: .muli)
        self.lblNotificationTitle.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblNotificationDescription.font = _theme.muliFont(size: 12, style: .muli)
        
        self.lblNotificationDate.textColor = _theme.textGreyColor
        self.lblNotificationDescription.textColor = _theme.textGreyColor
        self.lblNotificationTitle.textColor = _theme.textColor
    }
    
    func setData(notification: NotificationModel) {
        self.lblNotificationTitle.text = notification.notificationTitle
        self.lblNotificationDate.text = notification.formatedCreatedDate
        self.lblNotificationDescription.attributedText = notification.notificationContent.htmlToAttributedString
        
        self.btnCross.isHidden = !notification.isActive
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.delegate?.deleteNotification(with: self.indexPath)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

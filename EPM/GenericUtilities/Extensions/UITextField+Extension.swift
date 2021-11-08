//
//  UITextField+Extension.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date //2
        let currentDate = Date()
        var minimumDateComponents = DateComponents()
        minimumDateComponents.year = -100
        let minimumDate = Calendar.current.date(byAdding: minimumDateComponents, to: currentDate)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = currentDate
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func setInputViewButton(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
     // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func setInputViewDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
     // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: #selector(tapCancel))
        toolBar.setItems([flexible, cancel], animated: false)
        self.inputAccessoryView = toolBar
    }
   
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeftButton(_ image: String) {
        let paddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
        let imageView = UIImageView.init(frame: CGRect(x: paddingView.frame.size.width/2-5,y: 0, width: 10, height: paddingView.frame.size.height))
        paddingView.addSubview(imageView)
        imageView.contentMode = .center
        imageView.image = UIImage(named: image)
        self.leftViewMode = .always
        self.leftView = paddingView
        
    }
    
    func setRightButton(_ image: String) {
        let paddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        paddingView.isUserInteractionEnabled = false
        let imageView = UIImageView.init(frame: CGRect(x: paddingView.frame.size.width/2-5,y: 0, width: 10, height: paddingView.frame.size.height))
        paddingView.addSubview(imageView)
        imageView.contentMode = .center
        imageView.image = UIImage(named: image)
        self.rightViewMode = .always
        self.rightView = paddingView
    }
    
    enum Direction {
        case Left
        case Right
    }

    // add image to textfield
    func withImage(direction: Direction, image: UIImage){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.size.height))

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 8.0, width: 28.0, height: 28.0)
        mainView.addSubview(imageView)

        if(Direction.Left == direction){ // image left
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            self.rightViewMode = .always
            self.rightView = mainView
        }

    }
    
}

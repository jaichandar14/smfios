//
//  SegmentedControl+Extension.swift
//  EPM
//
//  Created by lavanya on 08/11/21.
//

import Foundation
import UIKit

// MARK: ACTIONS WHEN ITEM IS SELECTED IT HANDLES: ACTION - APPEREANCE - TRANSLATION
extension SegmentedControl {
    
    // MARK: MAIN ACTION: .valueChanged
    
    /// This method handle the value change event
    internal func performAction() {
        sendActions(for: .valueChanged)
    }
    
    // MARK: CHANGING APPEREANCE OF BUTTON ON TAP
    
    /// Button tap event on segmented control
    /// - Parameter button: button at the index that was tapped
    @objc internal func buttonTapped(button: UIButton) {
        
        for (btnIndex, btn) in self.buttons.enumerated() {
            
            btn.setTitleColor(textColor, for: .normal)
            if !itemsWithDynamicColor {
                if !buttonsWithDynamicImages {
                    btn.tintColor = buttonColorForNormal
                }
            }
            if btn == button {
                selectedSegmentIndex = btnIndex
                fillEqually ?  moveThumbView(at: btnIndex) : moveThumbViewFillEquallyFalse(at: btnIndex)
                btn.setTitleColor(selectedTextColor, for: .normal)
                if !itemsWithDynamicColor {
                    if !buttonsWithDynamicImages {
                        btn.tintColor = buttonColorForSelected
                    }
                }
            }
        }
        self.performAction()
    }
    
    // MARK: TRANSLATION OF THUMBVIEW WITH ANIMATION ON TAP
    
    //Movement of thumbview if fillEqually = true
    private func moveThumbView(at index: Int) {
        
        let selectedStartPosition = index == 0 ? (bounds.width / CGFloat(buttons.count))/2 - (SegmentedControl.bottomLineThumbViewWidth/2) : (bounds.width / CGFloat(buttons.count) *  CGFloat(index + 1)) -  (bounds.width / CGFloat(buttons.count))/2 - (SegmentedControl.bottomLineThumbViewWidth/2)
        for button in buttons {
            button.titleLabel?.font = titleFont
        }
        buttons[index].setTitleColor(selectedTextColor, for: .normal)
        buttons[index].titleLabel?.font = selectedTitleFont
        UIView.animate(withDuration: TimeInterval(self.animationDuration), animations: {
            self.thumbView.frame.origin.x = selectedStartPosition
        })
    }
    
    //Movement of thumbview if fillEqually = false
    private func moveThumbViewFillEquallyFalse(at index: Int) {
        
        let firstelementPositionX = self.padding
        let lastElemetPositionX = bounds.width - thumbView.frame.width - padding
        
        //the area where the selector is contained
        let selectorAreaTotalWidth = bounds.width / CGFloat(buttons.count)
        //startingPoint based on x position multiplier
        let startingPointAtIndex = selectorAreaTotalWidth *  CGFloat(index)
        //the remaining space of a selectorArea based on selector width
        let originXForNextItem = (selectorAreaTotalWidth - thumbView.bounds.width) / 2
        //dynamically change the origin x of the items between 0 and lastItem
        let selectedStartPositionForNotEquallyFill = startingPointAtIndex + originXForNextItem
        
        UIView.animate(withDuration: TimeInterval(self.animationDuration), animations: {
            
            if index == 0 {
                self.thumbView.frame.origin.x = firstelementPositionX
            } else if index == self.buttons.count - 1 {
                self.thumbView.frame.origin.x = lastElemetPositionX
            } else {
                self.thumbView.frame.origin.x = selectedStartPositionForNotEquallyFill
            }
        })
    }
}

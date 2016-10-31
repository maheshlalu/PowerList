//
//  TextFieldMaximumLength.swift
//  CoupCon
//
//  Created by Manishi on 10/31/16.
//  Copyright © 2016 CX. All rights reserved.
//


import UIKit
private var maxLengths = [UITextField: Int]()

extension UITextField {

    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                forControlEvents: UIControlEvents.EditingChanged
            )
        }
    }
    
    func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text
            where prospectiveText.characters.count > maxLength else {
                return
        }
        
        let selection = selectedTextRange
        text = prospectiveText.substringWithRange(
            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
        )
        selectedTextRange = selection
    }
    
}
//
//  DesignableUITextFieldViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 02/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
 @IBDesignable
class DesignableUITextFieldViewController: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding
    return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
    didSet {
    updateView()
    }
    }
    
    @IBInspectable var leftPadding: CGFloat = 4
    
    @IBInspectable var color: UIColor = UIColor.black {
    didSet {
    updateView()
    }
    }
    
    func updateView() {
    if let image = leftImage {
    leftViewMode = UITextFieldViewMode.always
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    imageView.image = image
    // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
    imageView.tintColor = color
    leftView = imageView
    } else {
    leftViewMode = UITextFieldViewMode.never
    leftView = nil
    }
    
    // Placeholder text color
    attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
    }
    }
    
    



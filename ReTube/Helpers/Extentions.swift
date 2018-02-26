//
//  Extentions.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import Foundation

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let ytRed = UIColor.rgb(red: 230, green: 32, blue: 31)
    static let ytRedDark = UIColor.rgb(red: 194, green: 31, blue: 31)
    static let ytLightGray = UIColor.rgb(red: 230, green: 230, blue: 230)
    static let menuSelectedColor = UIColor.rgb(red: 91, green: 14, blue: 13)
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UITextView {
    func lockEditing(lock: Bool) {
        isEditable = !lock
        isSelectable = !lock
    }
}

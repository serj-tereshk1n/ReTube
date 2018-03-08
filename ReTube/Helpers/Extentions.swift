//
//  Extentions.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import Foundation
extension NSObject {
    // MARK Utils
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeStringFromSeconds(seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
        return h > 0 ? "\(h)\(m):\(s)" : "\(m):\(s)"
    }
}

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
    
    func addFullScreenConstraintsFor(views: UIView..., inside: UIView) {
        for (_, view) in views.enumerated() {
            inside.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            inside.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
        }
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
}

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
        
        let strSec = s < 10 ? "0\(s)" : "\(s)"
        
        return h > 0 ? "\(h)\(m):\(strSec)" : "\(m):\(strSec)"
    }
}
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
extension String {
    
    func getYoutubeFormattedDuration() -> String {
        let formattedDuration = self.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with: ":").replacingOccurrences(of: "M", with: ":").replacingOccurrences(of: "S", with: "")
        
        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            duration = duration.characters.count > 0 ? duration + ":" : duration
            if component.characters.count < 2 {
                duration += "0" + component
                continue
            }
            duration += component
        }
        
        return duration
        
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
    
    #if false
    // TEELGRAM THEME
    // colors stolen from telegram
    static let darkBackground = UIColor.rgb(red: 24, green: 34, blue: 45)
    static let lightBackground = UIColor.rgb(red: 34, green: 48, blue: 63)
    static let subtitle = UIColor.rgb(red: 178, green: 195, blue: 212)
    static let blue = UIColor.rgb(red: 55, green: 168, blue: 252)
    // same colors as subtitle and blue
    static let deselected = UIColor.rgb(red: 178, green: 195, blue: 212)
    static let selected = UIColor.rgb(red: 55, green: 168, blue: 252)
    #else
    // YOURUBE DARK THEME
    // colors stolen from telegram
    static let darkBackground = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let lightBackground = UIColor.rgb(red: 35, green: 35, blue: 35)
    static let subtitle = UIColor.rgb(red: 135, green: 135, blue: 135)
    static let blue = UIColor.rgb(red: 230, green: 32, blue: 31)
    // same colors as subtitle and blue
    static let deselected = UIColor.white
    static let selected = UIColor.rgb(red: 230, green: 32, blue: 31)
    #endif
    
    // old colors
//    static let ytRed = UIColor.rgb(red: 230, green: 32, blue: 31)
//    static let ytRedDark = UIColor.rgb(red: 194, green: 31, blue: 31)
//    static let ytLightGray = UIColor.rgb(red: 230, green: 230, blue: 230)
//    static let menuSelectedColor = UIColor.rgb(red: 91, green: 14, blue: 13)
//
//    static let mDarkGray = UIColor.rgb(red: 25, green: 25, blue: 25)
//    static let mLightGray = UIColor.rgb(red: 35, green: 35, blue: 35)
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

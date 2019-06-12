//
//  LoadingIndicator.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 12.06.2019.
//  Copyright © 2019 Emre HAVAN. All rights reserved.
//

import UIKit

open class Indicator {
    
    internal static var indicator: UIActivityIndicatorView?
    
    public static var indicatorStyle: UIActivityIndicatorViewStyle = .whiteLarge
    
    public static var baseColor = UIColor.clear
    public static var color = UIColor.white
    
    public static func start(style: UIActivityIndicatorViewStyle = indicatorStyle, color: UIColor = color) {
        if indicator == nil, let window = UIApplication.shared.keyWindow {
            let width: CGFloat = 30.0
            let height: CGFloat = 30.0
            let frame = CGRect(x: (UIScreen.main.bounds.width / 2) - width / 2,
                               y: (UIScreen.main.bounds.height / 2) - height / 2,
                               width: width,
                               height: height)
            //let frame = UIScreen.main.bounds
            indicator = UIActivityIndicatorView(frame: frame)
            indicator?.backgroundColor = baseColor
            indicator?.activityIndicatorViewStyle = style
            indicator?.color = color
            window.addSubview(indicator!)
            indicator?.startAnimating()
        }
    }
    
    public static func stop() {
        if let indicator = indicator {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            self.indicator = nil
        }
    }
}
